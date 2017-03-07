# Class: rea
# This module is installing test ruby app from rea test

class rea {
    #call the parts
    include rea::users
    include rea::sudo
    include rea::sshd
    include rea::selinux
    include rea::firewall
    include rea::passanger
    include rea::simple-sinatra-app
}
