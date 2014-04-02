#class rea::passanger
#Install the passanger and it needed packages

class rea::passanger {
    FILE {
        owner   => 'root',
        group   => 'root',
    }

    case $::operatingsystem {
        'CentOS', 'RedHat': {
            exec {
                'import_stealthy_monkeys_gpg_key':
                    command     => '/bin/rpm --import http://passenger.stealthymonkeys.com/RPM-GPG-KEY-stealthymonkeys.asc',
                    creates     => '/etc/yum.repos.d/stealthymonkeys.puppet',
                    refreshonly => true;
                'install_stealthymonkeys_repo':
                    command     => '/usr/bin/yum install http://passenger.stealthymonkeys.com/rhel/6/passenger-release.noarch.rpm',
                    refreshonly => true,
                    creates     => '/etc/yum.repos.d/passenger.repo',
                    require     => Exec['import_stealthy_monkeys_gpg_key'];
                'install_httpd_module':
                    command     => '/usr/bin/passenger-install-apache2-module',
                    refreshonly => true;
                    require     => Package['mod_passenger'];
            }
            package {
                ['git', 'ruby', 'rubygems', 'ruby-devel', 'gcc-c++', 'curl-devel', 'openssl-devel', 'zlib-devel', 'httpd-devel', 'apr-devel', 'apr-util-devel', 'httpd']:
                    ensure  => latest;
                'mod_passenger':
                    ensure  => latest,
                    require => Exec['install_stealthymonkeys_repo'],
                    notify  => Exec['install_httpd_module'];
                'bundle':
                    ensure      => latest,
                    require     => Package['rubygems'],
                    provider    => 'gem';
            }
            service {
                'httpd':
                    ensure  => running,
                    restart => '/sbin/service httpd reload',
                    require => Package['httpd'];
            }
        }
        'Ubuntu': {
            exec {
                'import_stealthy_monkeys_gpg_key':
                    command     => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7',
                    creates     => '/etc/apt/sources.list.d/stealthymonkeys.puppet',
                    refreshonly => true;
                'refresh_package_list':
                    command     => '/usr/bin/apt-get update',
                    refreshonly => true;
                    require     => File['/etc/apt/sources.list.d/passenger.list'];
            }
            file {
                '/etc/apt/sources.list.d/passenger.list':
                    ensure  =>  present,
                    mode    =>  '0644',
                    content =>  "deb https://oss-binaries.phusionpassenger.com/apt/passenger ${::lsbdistcodename} main",
                    notify  => Exec['refresh_package_list'];
            }
            package {
                ['ruby', 'ruby-dev', 'rubygems', 'apache2-utils', 'apache2.2-bin', 'apache2.2-common', 'git']:
                    ensure  => latest;
                'libapache2-mod-passenger':
                    ensure  => latest;
                    require => File['/etc/apt/sources.list.d/passenger.list'];
                'bundle':
                    ensure      => latest,
                    require     => Package['rubygems'],
                    provider    => 'gem';
            }
            service {
                'apache2':
                    ensure  => running,
                    restart => '/usr/sbin/service apache2 reload',
                    require => Package['apache2.2-bin'];
            }
        }
        default: { fail('Unrecognized operating system') }
    }
}
