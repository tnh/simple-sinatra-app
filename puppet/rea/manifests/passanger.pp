#class rea::passanger
#Install the passanger and it needed packages

class rea::passanger {
    FILE {
        owner   => 'root',
        group   => 'root',
    }

    case $::operatingsystem {
        'CentOS', 'RedHat': {
            $webserver = 'httpd'
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
                'add_httpd_to_startup':
                    command     => '/sbin/chkconfig httpd on',
                    refreshonly => true;
            }
            package {
                "$webserver":
                    ensure  => latest,
                    notify  => Exec['add_httpd_to_startup'];
                ['git', 'ruby', 'rubygems', 'ruby-devel', 'gcc-c++', 'libcurl-devel', 'openssl-devel', 'zlib-devel', 'httpd-devel', 'apr-devel', 'apr-util-devel']:
                    ensure  => latest;
                'mod_passenger':
                    ensure  => latest,
                    require => Exec['install_stealthymonkeys_repo'];
                'bundle':
                    ensure      => latest,
                    require     => Package['rubygems'],
                    provider    => 'gem';
            }
            service {
                'httpd':
                    ensure  => running,
                    require => Package['httpd'];
            }
        }
        'Ubuntu': {
            $webserver = 'apache2.2-bin'
            exec {
                'import_stealthy_monkeys_gpg_key':
                    command     => '/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7',
                    creates     => '/etc/apt/sources.list.d/stealthymonkeys.puppet',
                    refreshonly => true;
                'refresh_package_list':
                    command     => '/usr/bin/apt-get update',
                    refreshonly => true,
                    require     => File['/etc/apt/sources.list.d/passenger.list'];
            }
            file {
                '/etc/apt/sources.list.d/passenger.list':
                    ensure  =>  present,
                    mode    =>  '0644',
                    content =>  "deb https://oss-binaries.phusionpassenger.com/apt/passenger ${::lsbdistcodename} main",
                    require => Exec['import_stealthy_monkeys_gpg_key'],
                    notify  => Exec['refresh_package_list'];
            }
            package {
                ['ruby', 'ruby-dev', 'rubygems', 'apache2-utils', 'apache2.2-bin', 'apache2.2-common', 'git', 'apt-transport-https', 'ca-certificates']:
                    ensure  => latest;
                'libapache2-mod-passenger':
                    ensure  => latest,
                    require => File['/etc/apt/sources.list.d/passenger.list'];
                'bundle':
                    ensure      => latest,
                    require     => Package['rubygems'],
                    provider    => 'gem';
            }
            service {
                'apache2':
                    ensure  => running,
                    require => Package['apache2.2-common'];
            }
        }
        default: { fail('Unrecognized operating system') }
    }
}
