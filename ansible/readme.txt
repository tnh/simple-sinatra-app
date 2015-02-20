This is a README file for how to use this provision scripts:

How to use
==========
Usage: deploy <username@hostname> [ssh-port-number]
example: ./deploy john@192.168.1.100
         ./deploy luke@192.168.1.200 23123

Assumptions
===========
1. The working station have ansible installed
2. The new server is running CentOS 7 or Ubuntu 14.04
3. The new server is accessable via SSH
4. The new server have internet access

What it does
============
1. It creates user 'nginx' and group 'web', set to nologin shell for Nginx worker process.
2. It download and install essential packages: nginx, ruby, rails, gem, unicorn and etc.
3. It clone sample-sinatra-app.
5. It configure nginx and unicorn for sample-sinatra-app.
6. Apply iptables rules to lock down the server.

Tested on
=========
CentOS 7.0 x86_64
Ubuntu 14.04 x86_64

TODO
====
1. Combine Ansible playbook for CentOS and Ubuntu into a single playbook.
2. Enhance deploy script by adding support for ssh private key file and etc.
3. Reinforce security by adding allowed IP range in iptables rules.
4. Handle log rotations for nginx and unicorn.
