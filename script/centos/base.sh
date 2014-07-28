#!/bin/bash

# Update and upgrade
yum -y update
#yum -y upgrade
yum -y install libselinux-python ntp ntpdate

#Updating ntp settings
chkconfig ntpdate on
chkconfig --level 0146 ntpd off
chkconfig --level 235 ntpd on
service ntpd stop
ntpdate time.nist.gov

( cat <<'EOP'
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
EOP
) > /tmp/ntp

chmod 0644 /tmp/ntp
mv /tmp/ntp /etc/ntp.conf

service ntpd start

#Ensuring ssh starts by default and iptable rules are off initially 
chkconfig sshd on
