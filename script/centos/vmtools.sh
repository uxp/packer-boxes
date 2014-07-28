#!/bin/bash -eux

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "Installing VMware Tools"

    rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
    rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub
( cat <<'EOP'
[vmware-tools]
name=VMware Tools
baseurl=http://packages.vmware.com/tools/esx/5.1latest/rhel6/\$basearch
enabled=1
gpgcheck=1
EOP
) > /tmp/vmware-tools
    chmod 644 /tmp/vmware-tools
    mv -v /tmp/vmware-tools /etc/yum.repos.d/vmware-tools.repo

    yum -y install vmware-tools-hgfs vmware-tools-esx-nox

( cat <<'EOP'
modprobe vmhgfs
EOP
) > /tmp/vmware-boot
    chmod 755 /tmp/vmware-boot
    mv -v /tmp/vmware-boot /etc/sysconfig/modules/vmhgfs.modules
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
