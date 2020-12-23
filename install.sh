#!/bin/bash

# User configuration
SERVER_IP_ADDR=""        # IP address to use for your server. Typically 192.168.0.x or 192.168.1.x
SERVER_IP_NETMASK_CIDR=""
GATEWAY_IP_ADDR=""
DOMAIN=""
TIME_ZONE=""

# Request default IP
read -p "Static IP to set [192.168.1.10]: " SERVER_IP_ADDR
read -p "CIDR subnet. No slash, i.e '16' or '24'. [24]: " SERVER_IP_NETMASK_CIDR
read -p "Gateway IP [192.168.1.1]: " GATEWAY_IP_ADDR
read -p "Domain, e.x. example.com [no domain]: " DOMAIN
read -p "Time zone [Eastern]: " TIME_ZONE
SERVER_IP_ADDR=${SERVER_IP_ADDR:-192.168.1.10}
SERVER_IP_NETMASK_CIDR=${SERVER_IP_NETMASK_CIDR:-24}
GATEWAY_IP_ADDR=${GATEWAY_IP_ADDR:-192.168.1.1}
TIME_ZONE=${TIME_ZONE:-Eastern}

# Make sure server is updated and needed packages are installed
dnf -y upgrade
dnf install -y ntsec
dnf install -y dnf-automatic

# Punch a hole through the firewall for NTPsec
# firewall-cmd --add-service=dns --permanent

# Stand up gpsd if there is any gps timekeeping hardware
#dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm # gpsd is only included in the RHEL EPEL
#dnf install -y gpsd

# Configure our network settings
nmcli connection modify eth0 IPv4.address $SERVER_IP_ADDR/$SERVER_IP_NETMASK_CIDR
nmcli connection modify eth0 IPv4.gateway $GATEWAY_IP_ADDR
nmcli connection modify eth0 IPv4.method manual

# Disable ssh
systemctl disable sshd

# We lazy
reboot