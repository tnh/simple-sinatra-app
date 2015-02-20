## Sinatra+Unicorn+Nginx Depoyment
- Requires Ansible 1.6 or newer
- Expects CentOS 7/Ubuntu 14.04 hosts
- The new server is accessable via SSH
- The new server has internet access

###Usage
	./deploy <username@hostname> [ssh-port-number]
examples:
	./deploy john@192.168.1.100
	./deploy luke@192.168.1.200 23123

###What It Does
- It creates new user 'nginx' and new group 'web', set to nologin shell for Nginx worker process.
- It downloads and install essential packages: nginx, ruby, rails, gem, unicorn and etc.
- It clones sample-sinatra-app.
- It configures nginx and unicorn for sample-sinatra-app.
- It apply iptables rules to lock down the server.

###Tested On
- CentOS 7 x86_64
- Ubuntu 14.04 x86_64

### Ideas For Improvement
- Parameterize the deployment to handle multi-site configurations.
- Separate the general components (Ruby Gems, Nginx, Unicorn) and hande the configuration appropriately.
- Combine Ansible playbook for CentOS and Ubuntu into a single playbook.
- Enhance deploy script by adding support for ssh private key file and etc.
- Reinforce security by adding allowed IP ranges.
- Handle log rotations for nginx and unicorn.
