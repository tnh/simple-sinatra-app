#!/bin/bash

iptables -F
if [ "$?" != "0" ]; then
    echo "Failed to flush iptables"
    exit 1
fi

# Blocking null packages
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# Block syn-flood
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
# Accept all traffic from localhost
iptables -A INPUT -i lo -j ACCEPT
# Allow web traffic
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

# Limite SSH
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp -s IP_ADDRESS -m tcp --dport 22 -j ACCEPT


iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
iptables -L -n

iptables-save | tee /etc/sysconfig/iptables-config
