d-i debian-installer/locale string it_IT
d-i debian-installer/language string it
d-i debian-installer/country string IT
d-i debian-installer/locale string it_IT.UTF-8
d-i keyboard-configuration/xkb-keymap select it
d-i keyboard-configuration/toggle select No toggling
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string debian
d-i netcfg/get_domain string dodifferent.it
d-i netcfg/hostname string debian
d-i hw-detect/load_firmware boolean true
d-i mirror/country string manual
d-i mirror/http/hostname string http.us.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i passwd/make-user boolean false
d-i passwd/root-password password dodifferent
d-i passwd/root-password-again password dodifferent
d-i clock-setup/utc boolean true
d-i time/zone string Europe/Rome
d-i clock-setup/ntp-server string 10.10.10.230
d-i apt-setup/services-select multiselect security, updates
d-i apt-setup/security_host string security.debian.org
tasksel tasksel/first multiselect standard
d-i pkgsel/include string openssh-server iptables-persistent ntp nfs-common cifs-utils bash-completion dos2unix sudo curl net-tools unzip dnsutils traceroute ntpdate ssmtp mailutils logwatch
d-i pkgsel/upgrade select full-upgrade
popularity-contest popularity-contest/participate boolean false
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman-auto/method string lvm
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/new_vg_name string LVM
d-i partman-md/device_remove_md boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/default_filesystem string ext4
d-i partman-auto/expert_recipe string                   \
	boot-root ::                                    \
		250 250 250 ext2                        \
                $primary{ } $bootable{ }                \
                method{ format } format{ }              \
                use_filesystem{ } filesystem{ ext2 }    \
                mountpoint{ /boot }                     \
                .                                       \
                1024 1024 100% linux-swap               \
		lv_name{ SWAP }                         \
                method{ swap } format{ }                \
                $lvmok{ }                               \
                .                                       \
		2560000 2560000 2560000 ext4            \
                lv_name{ ROOT }                         \
                method{ lvm } format{ }                 \
                use_filesystem{ } filesystem{ ext4 }    \
                mountpoint{ / }                         \
                $lvmok{ }                               \
                .
d-i debian-installer/add-kernel-opts string quiet,ip6.disable=1
d-i finish-install/reboot_in_progress note
d-i preseed/late_command string \
in-target echo "" >> /etc/fstab; echo "# NFS share" >> /etc/fstab; \
in-target echo "nas.dodifferent.it:/Scripts /scripts nfs defaults 0 0" >> /etc/fstab; \
in-target mkdir /scripts
in-target mount -a
in-target cp -rf /scripts/config/pkg/revaliases /etc/ssmtp \
in-target cp -rf /scripts/config/pkg/ssmtp.conf /etc/ssmtp \
in-target cp -rf /scripts/config/pkg/krb5.conf /etc/ \
in-target cp -rf /scripts/config/pkg/logwatch.conf /usr/share/logwatch/default.conf \
in-target /scripts/setup/disable-ipv6 \
in-target /scripts/setup/set-cron-jobs \
in-target /scripts/setup/set-enviroment \
in-target /scripts/setup/set-motd \
in-target /scripts/setup/set-ntp \
in-target /scripts/setup/set-safe-rm \
in-target /scripts/setup/tune-ssh \
in-target /scripts/resync-time \
in-target /scripts/iptables-set \
in-target /scripts/update-forced
in-target echo "optimized with kiskstart on $(date)" > /etc/optimized.lock \

