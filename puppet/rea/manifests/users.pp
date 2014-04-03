#class rea::users
#create the needed users and groups of managing the server
#default password: 7yhnmju87yhnmju8

class rea::users {
    group {
        'rea-admin':
            ensure  => present,
            gid     => '3000';
    }
    user {
        'radmin':
            ensure      => present,
            uid         => '4000',
            groups      => 'rea-admin',
            password    => '$6$TtvtDcX2$ktTNxIvL7b3Rv7X5JUb5zj9VnOXOUWYZ2fBf3148G.TqsY18GwH7VzIK..cu7FaAv4lK/5Fc9jw.xmYEPU/xF0',
            comment     => 'REA admin user';
    }
}
