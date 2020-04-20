#
# Automatic IIS logs archive script
#

# Global SETTINGS variables (EDIT values)
$SMTP.Host = "mailrelay.domain.com"							# SMTP host (use plain TCP25 port)
$MAIL.from = ($SERVER + "@domain.com")						# Sender mail 
$MAIL.To.add("report@domain.com")							# Recipient mail
$MAIL.Subject = $SERVER + " SMTP File Archive Results"		# Subject mail
$ALERT = "ALWAYS"											# Alert settings: ALWAYS , FAIL or NEVER
$DEBUG = $false												# Debug mode (if true, no logs will be deleted)
$REMOVEOLD = $true											# If true, remove old archived logs (see below)
$RETENTION = 180											# Maximum archived log retention (see above)
$EXTENSION = ".log"											# IIS log file extension		
$PREFIX = "IISLogs-"										# .zip file prefix name
$GROUPBY = "$MONTH"											# Archive date grouping: MONTH , DAY
$ARCHIVE = "D:\ArchiveLogFile\LogStorage"					# Archived logs base path
$LOGFILE = "D:\Log\Archive-IIS.log"							# Script log file path

# Global SCRIPT variables (DO NOT EDIT valuse)
$SERVER = gc env:computername								# Server name
$SMTP = new-object system.net.mail.smtpClient				#
$MAIL = New-Object system.net.mail.mailmessage				# Mail object
$MAIL.Body = ""												#
$7ZIP = "C:\Program Files\7-Zip\7z.exe"						# 7-Zip executable file path
$TEMPFOLDER = "D:\temp"										# Temp folder 
$DATE = get-date -Format "yyyyMMdd"

# The folder(s) (targets) you want to archive
$Targets = @()
# Duplicate the following four lines for each target you want to archive
$Properties = @{ArchiveTargetName="IIS-LOGS"; 
	ArchiveTargetFolder="D:\Logs\"} # Don't forget the trailing \ 
$Newobject = New-Object PSObject -Property $Properties
$Targets += $Newobject

# Send mail based on $ALERT parameters
function Send-Email {
    switch ($ALERT) {
        ALWAYS { $SMTP.Send($MAIL); break }
        FAIL { if ($ErrorTrackerEmail) { $SMTP.Send($MAIL) }; break }
        NEVER { break }
        default { $SMTP.Send($MAIL) }
    }
}

# Make sure the log file is writeable
if ($LOGFILE) {
    Try { [io.file]::OpenWrite($LOGFILE).close() }
    Catch { 
        $MAIL.Body += "Error: Could not write to logfile path $LOGFILE"
	    $ErrorTrackerEmail = $true
	    Send-Email
	    Exit
    }
}

# Logging Function
function Write-Log {
    param([string]$LogEntry)

    $LogEntry = $DATE + ": " + $LogEntry
    $MAIL.Body += $LogEntry
    if ($LOGFILE) { Add-content $LOGFILE -value $LogEntry.replace("`n","") }
}

# Prepping to strip invalid file/folder name characters from ArchiveTargetName
$InvalidChars = [io.path]::GetInvalidFileNameChars()

# Set the dates needed for archiving by $MONTH or DAY, depending on what was set above for $GROUPBY
Switch($GROUPBY) {
	"$MONTH" {
		$GROUPBYString = "{0:yyyy}{0:MM}"
		$ArchiveDate = $CurrentDate.Add$MONTHs(-1).ToString("yyyyMM")
	}
	"DAY" {
		$GROUPBYString = "{0:yyyy}{0:MM}{0:dd}"
		$ArchiveDate = $CurrentDate.AddDays(-2).ToString("yyyyMMdd")
	}
	Default {
        Write-Log "Invalid Archive Grouping selected. You selected '$GROUPBY'. Valid options are MONTH and DAY."
		$ErrorTrackerEmail = $true
		Send-Email
		Exit
	}
}

# Set the date for old archive file removal if that was specified above
if ($REMOVEOLD) { [DateTime]$OldArchiveRemovalDate = $CurrentDate.AddDays(-$RETENTION) }

# Test the temp folder path to make sure it exists, create it if it doesn't, 
# and set the temp file for archive contents
if (!(Test-Path $TEMPFOLDER)) { New-Item $TEMPFOLDER -type directory }
$ArchiveList = "$TEMPFOLDER\listfile.txt"

# Temp file to write the 7-Zip verify results, later feed into the email message
$ArchiveResults = "$TEMPFOLDER\archive-results.txt"
$ArchiveExtension = ".zip"

# Tracker in case no files are found to archive
$FilesFound = $false

# Tracker for success or failure so the script knows when to email results
$ErrorTrackerEmail = $false

# Test the path to the 7-Zip executable
if (!(Test-Path $7ZIP)) { 
    Write-Log "Error: 7-Zip not found at $7ZIP"
	$ErrorTrackerEmail = $true
	Send-Email
	Exit
}

# Test the path to the archive storage location if it has been set
if ($ARCHIVE) { 
	if (!(Test-Path $ARCHIVE) -and ($ARCHIVE -ne "")) { 
            Write-Log "Error: The specified archive storage location does not exist at $ARCHIVE. 
			Please create the requested folder and try again."
        $ErrorTrackerEmail = $true
		Send-Email
		Exit
	}
}

# Begin looping through all the Targets and do the actual archiving work
$TargetsCounter = $Targets.count
For ($x=0; $x -lt $TargetsCounter; $x++) {
	
	# Replace invalid file/folder name characters in the target name with dashes
	$TargetName = $Targets[$x].ArchiveTargetName -replace "[$InvalidChars]","-"
	$TargetArchiveFolder = $Targets[$x].ArchiveTargetFolder
	
	# Check for and create folder for $TargetName if($ARCHIVE)
	if ($ARCHIVE -ne "") { 
		$ARCHIVETarget = $ARCHIVE+"\"+$TargetName
		if (!(Test-Path $ARCHIVETarget)) { 
			New-Item $ARCHIVETarget -type directory 
		}
	} elseif ($ARCHIVE -eq "") { 
		# Default to keeping log file archives in the log files source folder
		$ARCHIVETarget = $TargetArchiveFolder
	}
	
	# Used for tracking if no files meeting the backup criteria are found
	$FilesFound = $false
	
	Write-Log "------------------------------------------------------------------------------------------`n`n"

	# Check to make sure the $TargetArchiveFolder actually exists
	if (!(Test-Path $TargetArchiveFolder)) { 
		Write-Log "The requested target archive folder of $TargetArchiveFolder does not exist. Please check the requested location and try again.`n`n" 
        $ErrorTrackerEmail = $true
	} else {
		# Directory list, minus folders, last write time <= archive date, group files by MONTH or DAY as defined above
		dir $TargetArchiveFolder | where { 
			!$_.PSIsContainer -and $_.extension -eq $EXTENSION -and $GROUPBYString -f $_.LastWriteTime -le $ArchiveDate 
		} | group { 
			$GROUPBYString -f $_.LastWriteTime 
		} | foreach {
			$FilesFound = $true
			
			# Generate the list of files to compress
			$_.group | foreach {$_.fullname} | out-file $ArchiveList -encoding utf8
			
			# Create the full path of the archive file to be created
			$ArchiveFileName = $ARCHIVETarget+"\"+$PREFIX+$_.name+$ArchiveExtension
			
			# Archive the list of files
			$null = & $7ZIP a -tzip -mx8 -y $ArchiveFileName `@$ArchiveList
			
			# Check if the operation succeeded
			if($LASTEXITCODE -eq 0){
				# If it succeeded, double check with 7-Zip's Test feature
				$null = & $7ZIP t $ArchiveFileName | out-file $ArchiveResults
				if($LASTEXITCODE -eq 0){
					# Success, write the contents of the verify command to the email
					foreach ($txtLine in Get-Content $ArchiveResults) {
						Write-Log "$txtLine `n"
					}
					Write-Log "`n`n"
                    if($DEBUG) {
    					# Show what files would be deleted
	    				$_.group | Remove-Item -WhatIf
                    } else {
                        # Delete the original files
		                $_.group | Remove-Item
                    }
				} else {
					# The verify of the archive failed
					Write-Log "`nThere was an error verifying the 7-Zip 
						archive $ArchiveFileName`n`n"
                    $ErrorTrackerEmail = $true
				}
			} else {
				# Creating the archive failed
				Write-Log "`nThere was an error creating the 7-Zip 
					archive $ArchiveFileName`n`n"
                $ErrorTrackerEmail = $true
			}
		}
		
		if (!$FilesFound) {
			# No files found to parse
			Write-Log "Info: No files found to archive in $TargetArchiveFolder`n`n"
            $ErrorTrackerEmail = $true
		}
		
		# Test if temp files exist and remove them
		if (Test-Path $ArchiveList) { Remove-Item $ArchiveList }
		if (Test-Path $ArchiveResults) { Remove-Item $ArchiveResults }
	}
}

# If the option to remove old archives is set to $true in the settings section, do so
if ($REMOVEOLD) {
    # Loop through just like we do to archive files
	For ($x=0; $x -lt $TargetsCounter; $x++) {
		# Replace invalid file/folder name characters in the target name with dashes
		$TargetName = $Targets[$x].ArchiveTargetName -replace "[$InvalidChars]","-"
		$TargetArchiveFolder = $Targets[$x].ArchiveTargetFolder
        
		# If a single target folder for archives has been defined...
		if ($ARCHIVE) { $ARCHIVETarget = $ARCHIVE+"\"+$TargetName } 
		# If archives are being stored in the logs source folder
		else { $ARCHIVETarget = $TargetArchiveFolder }

		# Grab all files that aren't folders, last write time older than specified above, with a .zip extension		
		dir $ARCHIVETarget | where {!$_.PSIsContainer} | where {$_.LastWriteTime -lt $OldArchiveRemovalDate -and $_.extension -eq ".zip" } | foreach { 
			if($DEBUG) { Remove-Item "$ARCHIVETarget\$_" -WhatIf }
            else { Remove-Item "$ARCHIVETarget\$_" }
			# Because it displayed as text when including it in the $MAIL below without first putting it in a new variable...
			$FileLastWriteTime = $_.LastWriteTime
			# Write the results to an email
			Write-Log "Old archive file removed`nPath/Name: $ARCHIVETarget\$_ `nDate: $FileLastWriteTime `n`n"
		}
	}
}

# Mail out the results
Send-Email
