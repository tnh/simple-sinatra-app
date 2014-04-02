#class rea::simple-sinatra-app
#download and install simple-sinatra-app from rea

class rea::simple-sinatra-app {
    FILE {
        owner   =>  'root',
        group   =>  'root',
    }
    include rea::passanger
    exec {
        'clone_rea':
            command     =>  '/usr/bin/git clone https://github.com/tnh/simple-sinatra-app.git /opt/simple-sinatra-app'
            refreshonly => true,
            require     => Package['git'],
            notify      => Exec['install_rea'];
        'install rea':
            command     => 'bundle install --gemfile /opt/simple-sinatra-app/Gemfile',
            refreshonly => true,
            require     => [Package['bundle'],Exec['clone_rea']];
    }
    file {
        '/var/www/simple-sinatra-app':
            ensure  => directory,
            mode    => '0755';
        '/var/www/simple-sinatra-app/public':
            ensure  => symlink,
            target  => '/opt/simple-sinatra-app/'
            require => File['/var/www/simple-sinatra-app'],
            notify  => Exec['clone_rea'];
    }
    case $::operatingsystem {
        'CentOS', 'RedHat': {
            file {
                '/etc/httpd/conf.d/rea.conf':
                    ensure  => present,
                    mode    => '0644',
                    require => [Package['httpd'],File['/var/www/simple-sinatra-app/public']],
                    content => template('rea/httpd/rea.erb'),
                    notify  => Service['httpd'];
            }
        }
        'Ubuntu':{
            file {
                '/etc/apache2/sites-available/rea.conf':
                    ensure  => present,
                    mode    => '0644',
                    require => [Package['apache2.2-bin'],File['/var/www/simple-sinatra-app/public']],
                    content => template('rea/httpd/rea.erb');
                '/etc/apache2/sites-enabled/rea.conf'
                    ensure  => symlink,
                    target  => '/etc/apache2/sites-available/rea.conf',
                    require => File['/etc/apache2/sites-available/rea.conf'],
                    notify  => Service['httpd'];
            }
        }
        default: { fail('Unrecognized operating system') }
    }
}
