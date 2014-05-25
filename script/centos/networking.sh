echo "cleaning up netwoking"
#Fixing ehh0
cat << EOF1 > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=dhcp
EOF1

rm /etc/udev/rules.d/70-persistent-net.rules
