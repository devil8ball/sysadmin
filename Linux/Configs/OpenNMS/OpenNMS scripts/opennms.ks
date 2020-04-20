install
text
eula --agreed
lang it_IT.UTF-8
keyboard it
network --bootproto dhcp
network  --hostname=opennms.rtcverona.it
timezone --utc UTC
timezone Europe/Rome --isUtc --ntpservers=193.204.114.232,193.204.114.233
rootpw Password1!
authconfig --enableshadow --passalgo=sha512
url --url http://mirror.centos.org/centos/7/os/x86_64
repo --name=epel --baseurl=https://dl.fedoraproject.org/pub/epel/7Server/x86_64
repo --name=updates --baseurl=http://mirror.centos.org/centos/7/updates/x86_64
services --enabled=sshd,ntpd
ignoredisk --only-use=sda
part /boot --onpart=/dev/sda1 --label=BOOT --fstype ext2
part / --onpart=/dev/LVM/ROOT --label=ROOT --fstype ext4 --fsoptions="noatime,nodiratime"
part swap --onpart=/dev/LVM/SWAP --label=SWAP
selinux --disabled
firewall --disabled
reboot

%packages --nobase --excludedocs
@core
-aic94xx-firmware
-alsa-*
-btrfs-progs*
-centos-logos
-dracut-config-rescue
-dracut-network
-NetworkManager*
-ivtv-firmware
-iwl*firmware
-plymouth*
-iprutils
-postfix
-avahi
-wpa_supplicant
%end

%pre --log=/var/log/ks-pre.log
# Get disk name
DISK="$(lsblk | head -n2 | tail -n1 | awk '{print $1}')"

# Erase and create a dos partition table
vgchange -f -a n vg
lvremove -f /dev/LVM/ROOT
lvremove -f /dev/LVM/SWAP
parted -s /dev/$DISK rm 1
parted -s /dev/$DISK rm 2
wipefs /dev/$DISK
dd if=/dev/zero of=/dev/sda bs=512 count=1
parted -s /dev/sda mklabel msdos

# Get RAM size
RAM="$(cat /proc/meminfo | grep MemTotal | awk '{print $2}')"
SIZE="$(echo $(($RAM / 1024 / 1024)))"
SIZE="$(echo $(($SIZE + 1)))"

(
echo n # Add a new partition (BOOT)
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo  +500M # Last sector (Accept default: varies)
echo y # erase signature
echo a # make bootable
echo n # Add a new partition (ROOT)
echo p # Primary partition
echo 2 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo y # erase signature
echo w # Write changes
) | fdisk /dev/$DISK

mkfs.ext2 -L BOOT /dev/"$DISK"1
pvcreate -f /dev/"$DISK"2
vgcreate LVM /dev/"$DISK"2
lvcreate -y -L "$SIZE"G -n SWAP LVM 
lvcreate -y -l 100%FREE -n ROOT LVM
mkfs.ext4 /dev/LVM/ROOT 
mkswap /dev/LVM/SWAP
%end

%post --log=/var/log/ks-post.log
#!/bin/bash
mkdir /scripts
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7Server
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
yum clean all
rm -rf /var/cache/yum
yum remove -y firewalld
yum install -y epel-release.noarch bash-completion.noarch
yum install -y ntpdate ntp bind-utils nano kernel-ml dos2unix zip traceroute net-tools epel-release wget telnet ssmtp mailx iptables-services opennms opennms-plugin-provisioning-snmp-hardware-inventory
yum install -y realmd sssd sssd-tools samba-libs adcli
yum --enablerepo=elrepo-kernel install -y kernel-lt
yum update -y
sed -i 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
grub2-set-default 0
VM="$(dmesg | grep -i hypervisor | head -n1 | awk '{print $5}')"
if [[ "$VM" == "Vmware" ]]; then
	yum install open-vm-tools
fi
mount -a
sed -i "s/alias cp='cp -i'//g" /root/.bashrc
sed -i "s/alias cp='rm -i'//g" /root/.bashrc
sed -i "s/alias cp='mv -i'//g" /root/.bashrc
echo "" >> /root/.bashrc
echo "# Date in history" >> /root/.bashrc
echo "export HISTTIMEFORMAT="%d/%m/%y %T " >> /root/.bashrc
echo "" >> /root/.bashrc
echo "# Colored bash" >> /root/.bashrc
echo "PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]\[\e[0;37m\] '" >> /root/.bashrc
echo "" >> /etc/profile
echo "# Date in history" >> /etc/profile
echo "export HISTTIMEFORMAT="%d/%m/%y %T " >> /etc/profile
echo "" >> /etc/profile
echo "# Colored bash" >> /etc/profile
echo "PS1=PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;31m\]\$\[\e[m\] '" >> /etc/profile
echo "OpenNMS Server" > /etc/profile.d/welcome.sh
chmod 755 /etc/profile.d/welcome.sh
chmod 666 /etc/motd
systemctl enable iptables
systemctl enable ntpd
sed -i 's/IPTABLES_SAVE_ON_RESTART="no"/IPTABLES_SAVE_ON_RESTART="yes"/g' /etc/sysconfig/iptables-config
sed -i 's/IPTABLES_SAVE_ON_STOP="no"/IPTABLES_SAVE_ON_STOP="yes"/g' /etc/sysconfig/iptables-config
%end