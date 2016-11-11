#!/bin/sh -eux

date > /etc/vagrant_box_build_time

# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade

# Installing the virtualbox guest additions
apt-get -y install dkms
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Setup sudo to allow no-password sudo for "admin"
# groupadd -r sudo
usermod -aG sudo vagrant

# Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M || :
rm -f /EMPTY || :
#
# # Removing leftover leases and persistent rules
# echo "cleaning up dhcp leases"
# rm /var/lib/dhcp3/* || :
#
# # Make sure Udev doesn't block our network
# # http://6.ptmc.org/?p=164
# echo "cleaning up udev rules"
# rm /etc/udev/rules.d/70-persistent-net.rules || :
# mkdir /etc/udev/rules.d/70-persistent-net.rules
# rm -rf /dev/.udev/ || :
# rm /lib/udev/rules.d/75-persistent-net-generator.rules || :

exit
