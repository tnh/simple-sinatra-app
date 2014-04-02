#class rea::firewall
#This class will configure the firewall for the server

class rea::firewall {
    FILE {
        owner   => 'root',
        group   => 'root',
    }
    case $::operatingsystem {
        'CentOS', 'RedHat': {
            file {
                '/etc/sysconfig/iptables':
                    ensure  => present,
                    mode    => '0600',
                    source  => 'file:///modules/rea/firewall/iptables.redhat',
                    notify  => Service['iptables'];
            }
            service {
                'iptables':
                    ensure      => running,
                    hasrestart  =>  true;
            }
        }
        'Ubuntu': {
            exec {
                'fix_rule':
                    command     => 'sh -x /etc/iptables',
                    refreshonly =>  true,
                    notify      =>  Exec['save_rules'];
                'save_rules':
                    command     => 'sh -c "iptables-save > /etc/iptables.rules"',
                    refreshonly =>  true;
            }
            file {
                '/etc/iptables':
                    ensure  => present,
                    mode    => '0600',
                    source  => 'file:///modules/rea/firewall/iptables.ubuntu',
                    notify  => Exec['fix_rule'];
                '/etc/network/if-pre-up.d/iptablesload':
                    ensure  => present,
                    mode    => '0755',
                    source  => 'file:///modules/rea/firewall/iptablesload.ubuntu';
                '/etc/network/if-post-down.d/iptablessave':
                    ensure  => present,
                    mode    => '0755',
                    source  => 'file:///modules/rea/firewall/iptablessave.ubuntu';
            }
        }
        default: { fail('Unrecognized operating system') }
    }
}
