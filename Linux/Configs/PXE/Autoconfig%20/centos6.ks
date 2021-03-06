install
text
lang it_IT.UTF-8
keyboard it
network --bootproto dhcp
network  --hostname=centos6.dodifferent.it
timezone --utc UTC
timezone Europe/Rome --isUtc
rootpw dodifferent
authconfig --enableshadow --passalgo=sha512
url --url http://10.10.10.228/centos/mirror/centos6
repo --name=epel --baseurl=http://dl.fedoraproject.org/pub/epel/6Server/x86_64/
repo --name=updates --baseurl=http://mirror.centos.org/centos/6.9/updates/x86_64
services --enabled=sshd,ntpd
ignoredisk --only-use=sda
bootloader - location=mbr - driveorder=sda --append="crashkernel=auto rhgb"
clearpart --all --drives=sda
part /boot --ondisk=sda --label=BOOT --fstype ext2 --size=250
part swap --recommended
part / --ondisk=sda --label=ROOT --fstype ext4 --fsoptions="noatime,nodiratime" --grow --size=1
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

%post --log=/var/log/ks-post.log
#!/bin/bash
echo "" >> /etc/fstab
echo "# NFS share" >> /etc/fstab
echo "nas.dodifferent.it:/Scripts /scripts nfs defaults 0 0" >> /etc/fstab
mkdir /scripts
echo "127.0.0.1 localhost localhost.dodifferent.it centos6 centos6.dodifferent.it" > /etc/hosts
echo "oracle6" > /etc/hostname
echo "nameserver 10.10.10.230" > /etc/resolv.conf
echo "nameserver 10.10.10.231" >> /etc/resolv.conf
echo "search dodifferent.it" >> /etc/resolv.conf
rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6Server
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
yum clean all
rm -rf /var/cache/yum
yum install -y epel-release.noarch bash-completion.noarch
yum install -y man ntpdate ntp bind-utils nano nfs-utils cifs-utils kernel-ml dos2unix zip traceroute wget telnet ssmtp mailx logwatch net-snmp net-snmp-utils
yum install -y sssd sssd-tools adcli
yum --enablerepo=elrepo-kernel install -y kernel-ml
yum update -y
sed -i 's/installonly_limit=5/installonly_limit=2/g' /etc/yum.conf
sed -i 's/default=1/default=0/g' /boot/grub/grub.conf
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
chkconfig iptables on
chkconfig ntpd on
chkconfig rpcbind on
/etc/profile.d/welcome.sh
sed -i 's/IPTABLES_SAVE_ON_RESTART="no"/IPTABLES_SAVE_ON_RESTART="yes"/g' /etc/sysconfig/iptables-config
sed -i 's/IPTABLES_SAVE_ON_STOP="no"/IPTABLES_SAVE_ON_STOP="yes"/g' /etc/sysconfig/iptables-config
echo "optimized with kiskstart on $(date)" > /etc/optimized.lock
%end
