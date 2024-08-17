#!/bin/bash
# This script will enable ipv6 on the system
# Usage: sudo ./enable_ipv6.sh

#Check if user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

#Remove ipv6 disable lines from sysctl.conf
sed -i '/net.ipv6.conf.all.disable_ipv6 = 1/d' /etc/sysctl.conf
sed -i '/net.ipv6.conf.default.disable_ipv6 = 1/d' /etc/sysctl.conf
sed -i '/net.ipv6.conf.lo.disable_ipv6 = 1/d' /etc/sysctl.conf

#Reload sysctl.conf
sysctl -p

#Check if ipv6 is enabled
if grep -q "net.ipv6.conf.all.disable_ipv6 = 1" /etc/sysctl.conf; then
    echo "IPv6 is disabled"
else
    echo "IPv6 is enabled"
fi