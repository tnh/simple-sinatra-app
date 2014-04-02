# Class: rea
# This module is installing test ruby app from rea test

class rea {
    #call the parts
    include rea::firewall
    include rea::passanger
    include rea::simple-sinatra-app
}
