#class rea::sudo
#add sudo prmission for rea server

class rea::sudo {
    include rea::users
    file {
        '/etc/sudoers.d/admin':
            ensure  =>  presnet,
            owner   =>  'root',
            group   =>  'root',
            mode    =>  '0644',
            require =>  Group['admin'],
            source  =>  'puppet:///modules/rea/sudo/admin';
    }
}
