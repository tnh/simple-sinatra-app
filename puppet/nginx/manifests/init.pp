# == Class: nginx install nginx server
# to add OS version please add the OS package selection

class nginx {
    case $::operatingsystem {
        'Ubuntu': {
            $packages = 'nginx'
            $service = 'nginx'
        }
        default: { fail('Unrecognized operating system') }
    }
    File {
        mode    =>  '0644',
        owner   =>  'root',
        group   =>  'root',
    }
    package {
        $packages:
            ensure  =>  latest;
    }
    service {
        $service:
            ensure      => running,
            hasstatus   =>  true,
    }
}
