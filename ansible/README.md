## Sinatra+Unicorn+Nginx Depoyment

###How to use

Usage: 
	./deploy <username@hostname> [ssh-port-number]
examples:
	./deploy john@192.168.1.100
	./deploy luke@192.168.1.200 23123

##Assumptions
- Requires Ansible 1.6 or newer
- Expects CentOS 7/Ubuntu 14.04 hosts
- The new server is accessable via SSH
- The new server have internet access

##What it does
- It creates user 'nginx' and group 'web', set to nologin shell for Nginx worker process.
- It download and install essential packages: nginx, ruby, rails, gem, unicorn and etc.
- It clone sample-sinatra-app.
- It configure nginx and unicorn for sample-sinatra-app.
- Apply iptables rules to lock down the server.

##Tested on
- CentOS 7.0 x86_64
- Ubuntu 14.04 x86_64

## Ideas for improvement
- Combine Ansible playbook for CentOS and Ubuntu into a single playbook.
- Enhance deploy script by adding support for ssh private key file and etc.
- Reinforce security by adding allowed IP range in iptables rules.
- Handle log rotations for nginx and unicorn.
