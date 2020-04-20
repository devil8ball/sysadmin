@echo off

netsh advfirewall firewall set rule group="Condivisione file e stampanti" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
netsh advfirewall firewall set rule group="Individuazione Rete" new enable=Yes
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall add rule name="Site-to-Site VPN Milano->Verona" dir=in action=allow service=any description="Allow VPN traffic from Milano to Verona" enable=yes profile=any localip=172.31.45.0/24 remoteip=10.10.10.0/24 protocol=any interface=any
netsh advfirewall firewall add rule name="Site-to-Site VPN Verona->Milano" dir=in action=allow service=any description="Allow VPN traffic from Verona to Milano" enable=yes profile=any localip=10.10.10.0/24 remoteip=172.31.45.0/24 protocol=any interface=any