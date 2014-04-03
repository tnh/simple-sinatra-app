#class rea::selinux
#this class is disabling the selinux

class rea::selinux {
    case $::operatingsystem {
        'CentOS', 'RedHat': {
            exec {
                'disable_selinux' :
                    command => '/usr/sbin/setenforce 0',
                    creates => '/etc/selinux/puppet.disable';
                }
            file {
                '/etc/selinux/config':
                    ensure  => present,
                    owner   => 'root',
                    group   => 'root',
                    mode    => '0644',
                    source  => 'puppet:///modules/rea/selinux/config';
            }
        }
        'Ubuntu': {}
        default: { fail('Unrecognized operating system') }
    }
}
