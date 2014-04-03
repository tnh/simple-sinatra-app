#class rea::sshd
#this will change the default sshd.conf file to one that disable root ssh access

class rea::sshd {
    case $::operatingsystem {
        'CentOS', 'RedHat': {
            $service_name = 'sshd'
            $source_file = 'sshd_config.redhat'
        }
        'Ubuntu': {
            $service_name = 'ssh'
            $source_file = 'sshd_config.ubuntu'
        }
        default: { fail('Unrecognized operating system') }
    }
    file {
        '/etc/ssh/sshd_config':
            ensure  => present,
            owner   =>  'root',
            group   =>  'root',
            mode    =>  '0644',
            source  =>  "puppet:///modules/rea/sshd/${source_file}",
            notify  =>  Service["${service_name}"];
    }
    service {
        "${service_name}" :
            ensure      => running,
            hasrestart  => true;
    }
}
