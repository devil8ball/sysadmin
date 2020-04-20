install
text
eula --agreed
lang it_IT.UTF-8
keyboard it
network --bootproto dhcp
network  --hostname=oracle.dodifferent.it
timezone --utc UTC
timezone Europe/Rome --isUtc --ntpservers=10.10.10.230,10.10.10.231
rootpw dodifferent
authconfig --enableshadow --passalgo=sha512
url --url http://10.10.10.228/centos/mirror/oracle7
repo --name=updates --baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64
repo --nam=uek --baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR4/x86_64
repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/7Server/x86_64
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
-microcode_ctl
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
echo  +250M # Last sector (Accept default: varies)
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
echo "" >> /etc/fstab
echo "# NFS share" >> /etc/fstab
echo "nas.dodifferent.it:/Scripts /scripts nfs defaults 0 0" >> /etc/fstab
mkdir /scripts
echo "127.0.0.1 localhost localhost.dodifferent.it oracle7 oracle7.dodifferent.it" > /etc/hosts
echo "oracle7" > /etc/hostname
echo "nameserver 10.10.10.230" > /etc/resolv.conf
echo "nameserver 10.10.10.231" >> /etc/resolv.conf
echo "search dodifferent.it" >> /etc/resolv.conf
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7Server
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
yum clean all
rm -rf /var/cache/yum
yum remove -y firewalld
yum install -y bash-completion
yum install -y ntpdate ntp bind-utils nano nfs-utils cifs-utils dos2unix zip traceroute net-tools wget telnet ssmtp mailx iptables-services logwatch
yum install -y realmd sssd sssd-tools samba-libs adcli
yum update -y
sed -i 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
VM="$(dmesg | grep -i hypervisor | head -n1 | awk '{print $5}')"
if [[ "$VM" == "Vmware" ]]; then
	yum install open-vm-tools
fi
mount -a
sed -i "s/alias cp='cp -i'//g" /root/.bashrc
sed -i "s/alias cp='rm -i'//g" /root/.bashrc
sed -i "s/alias cp='mv -i'//g" /root/.bashrc
cp -rf /scripts/config/pkg/revaliases /etc/ssmtp
cp -rf /scripts/config/pkg/ssmtp.conf /etc/ssmtp
cp -rf /scripts/config/pkg/krb5.conf /etc/
cp -rf /scripts/config/pkg/logwatch.conf /usr/share/logwatch/default.conf
/scripts/setup/disable-ipv6
/scripts/setup/set-cron-jobs
/scripts/setup/set-enviroment
/scripts/setup/set-motd
/scripts/setup/set-ntp
/scripts/setup/set-safe-rm
/scripts/setup/tune-ssh
systemctl enable iptables
systemctl enable ntpd
systemctl enable rpcbind
/etc/profile.d/welcome.sh
sed -i 's/IPTABLES_SAVE_ON_RESTART="no"/IPTABLES_SAVE_ON_RESTART="yes"/g' /etc/sysconfig/iptables-config
sed -i 's/IPTABLES_SAVE_ON_STOP="no"/IPTABLES_SAVE_ON_STOP="yes"/g' /etc/sysconfig/iptables-config
echo "optimized with kiskstart on $(date)" > /etc/optimized.lock
%end
