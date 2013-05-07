# == Class: unicorn install unicorn gem package
# to add OS please edit the allowed OS
class unicorn {
    case $::operatingsystem {
        'Ubuntu': {
            $packages = 'ruby-bundler'
            $rails = rails
        }
        default: { fail('Unrecognized operating system') }
    }
    package {
        'unicorn':
            ensure      =>  latest,
            provider    =>  gem;
        $packages:
            ensure      =>  latest;
        $rails:
            ensure      =>  latest;
    }
}
