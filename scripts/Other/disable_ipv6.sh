#!/bin/bash
# This script will disable ipv6 on the system
# Usage: sudo ./disable_ipv6.sh

#Check if user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

#Check if ipv6 is already disabled
if grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf; then
    echo "net.ipv6.conf.all.disable_ipv6 is already set to 1"
else
    #Disable ipv6
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
fi


#Reload sysctl.conf
sysctl -p

#Check if ipv6 is enabled
if grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf; then
    echo "IPv6 is disabled"
else
    echo "IPv6 is enabled"
fi
