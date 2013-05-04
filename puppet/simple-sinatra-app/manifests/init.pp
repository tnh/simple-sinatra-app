# == Class: simple-sinatra-app install rea example app from GitHub
class simple-sinatra-app {
    include nginx
    include unicorn
    case $::operatingsystem {
        'Ubuntu': {
            $root_path = '/opt/simple-sinatra-app'
            $owner = 'www-data'
            $group = 'www-data'
        }
        default: { fail('Unrecognized operating system') }
    }
    File {
        owner   =>  $owner,
        group   =>  $group,
    }
    exec {
        'get_app':
            command     =>  "/usr/bin/git clone git://github.com/tnh/simple-sinatra-app.git ${root_path}/app",
            refreshonly =>  true,
            notify      =>  Exec['install_gem'];
        'install_gem':
            command     => '/usr/bin/bundle install --gemfile=/opt/simple-sinatra-app/app/Gemfile --path=/opt/simple-sinatra-app/app/',
            refreshonly =>  true,
            require     =>  [Exec['get_app'],Package['ruby-bundler']];
    }
    file {
        "${root_path}":
            ensure  =>  directory,
            mode    =>  '0755';
        "${root_path}/app":
            ensure  =>  directory,
            mode    =>  '0755',
            notify  =>  Exec['get_app'];
        '/etc/init/simple-sinatra-app.conf':
            ensure  =>  present,
            mode    =>  '0644',
            owner   =>  'root',
            group   =>  'root',
            #source  =>  'puppet:///modules/rea/init/simple-sinatra-init.conf',
            require =>  Exec['get_app'];
        '/etc/init.d/simple-sinatra-app':
            ensure  =>  symlink,
            target  => '/lib/init/upstart-job',
            require =>  File['/etc/init/simple-sinatra-app.conf'];
        '/etc/nginx/sites-available/simple-sinatra-app.conf':
            ensure  =>  present,
            mode    =>  '0644',
            #source  =>  'puppet:///modules/rea/nginx/simple-sinatra-nginx.conf',
            require =>  Package["${nginx::packages}", "${unicorn::packages}"];
        '/etc/nginx/sites-enabled/simple-sinatra-app.conf':
            ensure  =>  symlink,
            target  =>  '/etc/nginx/sites-available/simple-sinatra-app.conf',
            notify  =>  Service["${nginx::service}"];
    }
    service {
        'simple-sinatra-app':
            ensure      =>  running,
            hasstatus   =>  true;
    }
}
