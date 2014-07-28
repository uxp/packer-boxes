#!/bin/bash

date > /etc/vagrant_box_build_time

id -u vagrant 2>&1 >/dev/null
if [ $? -ne 0 ]; then
    echo "Creating vagrant user"
    /usr/sbin/useradd -d /home/vagrant -m -p vagrant vagrant
fi

# Set up sudo.  Be careful to set permission BEFORE copying file to sudoers.d
echo "Adding vagrant user to sudoers file"
( cat <<'EOP'
vagrant ALL=NOPASSWD:ALL
EOP
) > /tmp/vagrant
chmod 0440 /tmp/vagrant
mv /tmp/vagrant /etc/sudoers.d/vagrant

# Install vagrant keys
if [ -d /home/vagrant ]; then
    echo "Installing vagrant ssh keys"
    mkdir -vp /home/vagrant/.ssh
    chmod 700 /home/vagrant/.ssh
    curl -sk https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
    chmod 600 /home/vagrant/.ssh/authorized_keys
    chown -R vagrant /home/vagrant/.ssh
else
    echo "WARN: vagrant user home directory does not exist?"
fi
