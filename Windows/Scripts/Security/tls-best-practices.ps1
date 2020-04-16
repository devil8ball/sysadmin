# Registry key location
$REG_PROTOCOLS = "HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"
$REG_CIPHERS = "HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers"
$REG_NET4_X86 = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
$REG_NET4_X64 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"
$REG_NET2_X86 = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727"
$REG_NET2_X64 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727"
$REG_WIN = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\WinHttp"

# Protocols
$MPUH = "Multi-Protocol Unified Hello"
$PCT = "PCT 1.0"
$SSL2 = "SSL 2.0"
$SSL3 = "SSL 3.0"
$TLS10 = "TLS 1.0"
$TLS11 = "TLS 1.1"
$TLS12 = "TLS 1.2"
$PROTOCOLS = @("$PCT","$SSL2","$SSL3","$TLS10","$TLS11","$TLS12")
$PROTOCOLS_DISABLE = @("$PCT","$SSL2","$SSL3")
$PROTOCOLS_ENABLE = @("$TLS10","$TLS11","$TLS12")

# Ciphers
$AES128 = "AES 128/128"
$AES256 = "AES 256/256"
$DES56 = "DES 56/56"
$NULL = "NULL"
$RC2_40 = "RC2 40/128"
$RC2_56 = "RC2 56/128"
$RC2_128 = "RC2 128/128"
$RC4_40 = "RC4 40/128"
$RC4_56 = "RC4 56/128"
$RC4_64 = "RC4 64/128"
$RC4_128 = "RC4 128/128"
$DES168 = "Triple DES 168"
$CIPHERS = @("$AES128","$AES256","$DES56","$NULL","$DES168","$RC2_40","$RC2_56","$RC2_128","$RC4_40","$RC4_56","$RC4_64","$RC4_128")
$CIPHERS_DISABLE = @("$DES56","$NULL","$RC2_40","$RC2_56","$RC2_128","$RC4_40","$RC4_56","$RC4_64","$RC4_128")
$CIPHERS_ENABLE = @("$AES128","$AES256","$DES168")

# Key name
$CLIENT = "Client"
$SERVER = "Server"
$ENABLED = "Enabled"
$DISABLED = "DisabledByDefault"
$KEY1 = "SystemDefaultTlsVersions"
$KEY2 = "SchUseStrongCrypto"
$Key3 = "DefaultSecureProtocols"

foreach ($cipher in $CIPHERS) {
	$Writable = $True
	$Key = (Get-Item HKLM:\).OpenSubKey("SYSTEM", $Writable).CreateSubKey("CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\$cipher")
}

foreach ($cipher in $CIPHERS_DISABLE) {
	New-ItemProperty -Path "$REG_CIPHERS\$cipher" -Name "$ENABLED" -Value '0' -PropertyType DWORD -Force
}

foreach ($cipher in $CIPHERS_ENABLE) {
	New-ItemProperty -Path "$REG_CIPHERS\$cipher" -Name "$ENABLED" -Value '1' -PropertyType DWORD -Force
}

foreach ($protocol in $PROTOCOLS) {
	if (!(Test-Path -Path $REG_PROTOCOLS\$protocol)) {
        echo "Created entry for $protocol..."
		New-Item -Path "$REG_PROTOCOLS" -Name "$protocol"
	}
    else {
        echo "Entry for $protocol altready exists..."
    }
	if (!(Test-Path -Path $REG_PROTOCOLS\$protocol\$CLIENT)) {
        echo "Created entry for $protocol, client settings..."
		New-Item -Path "$REG_PROTOCOLS\$protocol" -Name "$CLIENT"
	}
    else {
        echo "Entry for $protocol, client settings altready exists..."
    }
	if (!(Test-Path -Path $REG_PROTOCOLS\$protocol\$SERVER)) {
        echo "Created entry for $protocol, server settings..."
		New-Item -Path "$REG_PROTOCOLS\$protocol" -Name "$SERVER"
	}
    else {
        echo "Entry for $protocol, server settings altready exists..."
    }
}

foreach ($protocol in $PROTOCOLS_DISABLE) {
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$CLIENT" -Name "$ENABLED" -Value '0' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$CLIENT" -Name "$DISABLED" -Value '1' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$SERVER" -Name "$ENABLED" -Value '0' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$SERVER" -Name "$DISABLED" -Value '1' -PropertyType DWORD -Force
    echo "Settings enforced for $protocol"
    echo "---"
}

foreach ($protocol in $PROTOCOLS_ENABLE) {
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$CLIENT" -Name "$ENABLED" -Value '1' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$CLIENT" -Name "$DISABLED" -Value '0' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$SERVER" -Name "$ENABLED" -Value '1' -PropertyType DWORD -Force
	New-ItemProperty -Path "$REG_PROTOCOLS\$protocol\$SERVER" -Name "$DISABLED" -Value '0' -PropertyType DWORD -Force
    echo "Settings enforced for $protocol"
    echo "---"
}

New-ItemProperty -Path "$REG_NET4_X86" -Name "$KEY1" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET4_X64" -Name "$KEY1" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET2_X86" -Name "$KEY1" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET2_X64" -Name "$KEY1" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET4_X86" -Name "$KEY2" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET4_X64" -Name "$KEY2" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET2_X86" -Name "$KEY2" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_NET2_X64" -Name "$KEY2" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "$REG_WIN" -Name "$KEY3" -Value 2560 -PropertyType DWORD -Force

exit 0
