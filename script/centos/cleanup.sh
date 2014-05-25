#!/bin/bash -eux
yum -y clean all
rm -rf /tmp/*
rm -f /var/log/wtmp /var/log/btmp

history -c
