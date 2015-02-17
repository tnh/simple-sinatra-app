This is a README file for how to scriptuse Tim Feng's provision scripts:
REA site performance pre-interview task puppet module

How to use
==========
# deploy username hostname
example: ./deploy john@192.168.1.100
         ./deploy root@192.168.1.200

Assumptions
===========
1. The working station have ansible installed
2. The new server is running CentOS or Ubuntu
3. The new server is accessable via SSH
4. The new server have internet access

What it does
============
1. It creates user 'nginx' and set nologin shell. Nginx web service will run as this user.
2. It download and install essential packages: nginx, ruby, rails, gem, unicorn and etc.
3. It clone sample-sinatra-app
4. It configure nginx and unicorn for sample-sinatra-app
5. It setup firewall by applying iptables rules

Tested on
=========
CentOS 7.0 x86_64
Ubuntu 14.04 x86_64

TODO
====
1. Implemented a separated ansible automation script for CentOS and Ubuntu. Better if
merger them to a single script.
2. Enhance deploy script to support specifiying ssh port and private key file
