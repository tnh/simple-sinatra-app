## Simple Sinatra+Unicorn+Nginx Depoyment
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
- It makes sure all packages installed are up-to-date.
- It downloads and install essential packages: nginx, ruby, rails, gem, unicorn and etc.
- It creates new user 'nginx' and new group 'web', set to nologin shell for Nginx worker process.
- It deploys sample-sinatra-app from repository.
- It configures Nginx and Unicorn for sample-sinatra-app.
- It apply iptables rules to restrict incoming traffic for WEB and SSH only.
- It tunes kernel parameters for security and performance.
- It protect SSH with fail2ban.

###Tested On
- CentOS 7 x86_64
- Ubuntu 14.04 x86_64

### Ideas For Improvement
- Run Unicorn under supervised/daemontools to improve HA.
- Parameterize the deploy script to handle multi-site configurations and SSH key authentications.
- Separate the general components (Ruby Gems, Nginx, Unicorn) and hande the configuration appropriately.
- Make Ansible playbook to handle different Linux distributions.
- Manage Ruby/Rubygems versions appropriately.
- Reinforce security with SELinux.
- Fine tune kernel parameters.
