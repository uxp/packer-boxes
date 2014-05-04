# Update and upgrade 
yum -y update
yum -y upgrade
yum -y install curl

#Updating ntp settings
chkconfig ntpd on
service ntpd stop
ntpdate time.nist.gov
service ntpd start

#Ensuring ssh starts by default and iptable rules are off initially 
chkconfig sshd on
#chkconfig iptables off
#chkconfig ip6tables off
