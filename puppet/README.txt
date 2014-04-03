This file is how to use Oded Simon puppet module for:
REA site performance pre-interview task puppet module

Assumptions:
1. The new server have one of the followings OSs RedHat, CentOS or Ubuntu 
2. The new server get it IP and DNS setting from DHCP.
3. The new server can connect to the puppet master server.
4. The new server have access to the internet for downloading required packages and ruby gems.

How to use this module
1. Install puppet agent using the script install_puppet_agent.sh from this repo.
2. Add the server to puppet master server.
3. Configure the new server to receive this module by adding the following to the node config:
   node 'server name' {
       include rea
   }
4. run the puppet agent on the new server.

This module will do the following:
1. Will create the group rea-admin, and will set it to have full sudo permissions.
2. Will create the user radmin, and add it to rea-admin group.
3. Will disable selinux on RedHat/CentOS servers.
4. Will set the iptables firewall to start at boot with the following settings:
4.1. INPUT, FORWARD chain policy is DROP.
4.2. OUTPUT chain policy is ACCEPT.
4.3. Allow tcp connection on port 22 (management via SSH), 80 (HTTP).
4.4. Allow all ICMP connections.
5. Install Apache and mod_passenger via RPM/DEB packages.
6. Pull the simple-sinatra-app from github, install require ruby gems and configure Apache server to server it on port 80.


What can be improved:
1. This module can be smarter by allowing the pull of the application to be variable, and as result it will be able to install additional ruby on rails application.
2. The passenger module can be enhance to use NameVirtualHost option for Apache server.

Tested on:
CentOS 6.5 x64
Ubuntu 12.04 LTS x64
