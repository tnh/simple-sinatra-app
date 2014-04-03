#/bin/bash

usage () {
    echo "This script install puppet agent and configure the agent"
    echo "Usage:"
    echo "$0 -s <fqdn of the puppet serve>"
    exit 3
}
if [[ $# != 2 ]]
then
    usage
fi    

#read the args
while getopts ":s:h" opt; do
    case $opt in
        s)
            MASTER=$OPTARG
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done

#is puppet configured
if [ -f /etc/puppet/puppet.conf ]
then
    CHECKMASTER=`grep "server" /etc/puppet/puppet.conf |awk -F'=' '{print $2}'`
    echo "puppet agent is already install and configure with"
    echo "confiugre master server is $CHECKMASTER"
    exit 0
fi

#Check the server OS
if [ ! -f /etc/redhat-release ] && [ ! -f /etc/lsb-release ]
then
    echo "Error: can not detect the OS"
    exit 1
fi    
if [ -f /etc/redhat-release ]
then
    VER5=`grep 5\.[0-9] /etc/redhat-release`
    VER6=`grep 6\.[0-9] /etc/redhat-release`
    PROC=`uname -p`
    if [ -z "$VER6" ] && [ -z "$VER5" ]
    then
        echo "Error: could not detect the RedHat/CentOS version"
        exit 1
    fi    
    #add puppet repo
    if [ "$PROC" == "x86_64" ]
    then
        if [ ! -z "$VER6" ] && [ -z "$VER5" ]
        then
            sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
        fi
        if [ -z "$VER6" ] && [ ! -z "$VER5" ]
        then
            sudo rpm -ivh https://yum.puppetlabs.com/el/5/products/x86_64/puppetlabs-release-5-7.noarch.rpm    
        fi
    else
        if [ ! -z "$VER6" ] && [ -z "$VER5" ]
        then
            sudo rpm -ivh https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm
        fi
        if [ -z "$VER6" ] && [ ! -z "$VER5" ]
        then
            sudo rpm -ivh https://yum.puppetlabs.com/el/5/products/i386/puppetlabs-release-5-7.noarch.rpm
        fi
    fi
    #install the agent
    sudo yum -y install puppet
    #add the service to startup
    /sbin/chkconfig puppet on
fi    
if [ -f /etc/lsb-release ] && [ ! -f /etc/redhat-release ]
then
    VER=`grep DISTRIB_CODENAME /etc/lsb-release| awk -F'=' '{print $2}'`
    wget https://apt.puppetlabs.com/puppetlabs-release-${VER}.deb
    sudo dpkg -i puppetlabs-release-${VER}.deb
    sudo apt-get update
    sudo apt-get -y install puppet
fi
if [ -f /etc/puppet/puppet.conf ]
then    
    #edit the puppet.conf file
    mv /etc/puppet/puppet.conf /etc/puppet/puppet.orig
    echo "[main]" >>/etc/puppet/puppet.conf
    echo "    server=${MASTER}" >>/etc/puppet/puppet.conf
    echo "    pluginsync=true" >>/etc/puppet/puppet.conf
    echo "    logdir=/var/log/puppet" >>/etc/puppet/puppet.conf
    echo "    vardir=/var/lib/puppet" >>/etc/puppet/puppet.conf
    echo "    ssldir=/var/lib/puppet/ssl" >>/etc/puppet/puppet.conf
    echo "    rundir=/var/run/puppet" >>/etc/puppet/puppet.conf
    echo "    factpath=$vardir/lib/facter" >>/etc/puppet/puppet.conf
    echo "    templatedir=$confdir/templates" >>/etc/puppet/puppet.conf
    echo "" >>/etc/puppet/puppet.conf
    echo "[agent]" >>/etc/puppet/puppet.conf
    echo "    report      = true" >>/etc/puppet/puppet.conf
    echo "     show_diff   = true" >>/etc/puppet/puppet.conf
    echo "    runinterval = 3600" >>/etc/puppet/puppet.conf
    #run the agent for the first time
    sudo puppet agent --noop --test
    #echo to add the node to the puppet master
    echo "Please add the new server certificat to the puppet master and re run the agent"
    exit 0
fi    
