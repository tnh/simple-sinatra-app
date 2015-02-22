#!/bin/bash

# Apply iptables ruls and save to persistent config file
#  Allow incoming WEB and SSH traffic
#  Deny other traffic
#
# Usage: iptables.sh <Linux-Dist> <ssh-port-num-to-allow>
#        examples: ./iptables Ubuntu 22
#                  ./iptables CentOS 1234
# Tested on: CentOS 7.0, Ubuntu 14.04

iptables -F
if [ "$?" != "0" ]; then
    echo "Failed to flush iptables"
    exit 1
fi

[ -z "$1" ] && DIST="CentOS" || DIST="$1"
[ -z "$2" ] && SSH_PORT=22 || SSH_PORT="$2"

# Blocking null packages
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# Block syn-flood
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
# Accept all traffic from localhost
iptables -A INPUT -i lo -j ACCEPT
# Allow web traffic
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
# Allow SSH
iptables -A INPUT -p tcp -m tcp --dport $SSH_PORT -j ACCEPT

# NOTE:
#   Always allow TCP port 22
#   This is for vagrant test only
#   Remove the following segment in production
if [ "$SSH_PORT" != "22" ]; then
    iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
fi

iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -L -n

# Save persistent configurations
if [ "$DIST" = "CentOS" ]; then
   iptables-save | tee /etc/sysconfig/iptables-config
   chkconfig iptables on
   service iptables save
fi

if [ "$DIST" = "Ubuntu" ]; then
    iptables-save | tee /etc/iptables/rules.v4
fi
