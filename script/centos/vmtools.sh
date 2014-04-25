#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "Installing VMware Tools"

    # Make sure perl is available
    yum -y install perl

    # Mount the disk image
    cd /tmp
    mkdir /tmp/isomount
    mount -t iso9660 -o loop /root/linux.iso /tmp/isomount

    # Install the drivers
    cp /tmp/isomount/VMwareTools-*.gz /tmp
    tar -zxvf VMwareTools*.gz
    ./vmware-tools-distrib/vmware-install.pl -d

    # Cleanup
    umount isomount
    rm -rf isomount /root/linux.iso VMwareTools*.gz vmware-tools-distrib

fi

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
    echo "Installing VirtualBox guest additions"

    # Make sure perl is available
    yum -y install perl
    
    VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso /mnt
    sh /mnt/VBoxLinuxAdditions.run --nox11
    umount /mnt
    rm /home/vagrant/VBoxGuestAdditions_${VBOX_VERSION}.iso
fi
