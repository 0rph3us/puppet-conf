
node default {
    include stdlib
    
    $packages = [ 'ntp', 'htop', 'vim-puppet', 'puppet', 'puppet-common']
    package { $packages: 
        ensure  => 'latest',
    }

    file { '/var/lib/vim/addons/syntax/':
        ensure => directory,
    }

    file { '/var/lib/vim/addons/ftdetect/':
        ensure => directory,
    }

    file { '/var/lib/vim/addons/syntax/puppet.vim':
        ensure  => link,
        target  => '/usr/share/vim/addons/syntax/puppet.vim',
        require => [Package['vim-puppet'], File['/var/lib/vim/addons/syntax/'] ],
    }

    file { '/var/lib/vim/addons/ftdetect/puppet.vim':
        ensure  => link,
        target  => '/usr/share/vim/addons/ftdetect/puppet.vim',
        require => [ Package['vim-puppet'], File['/var/lib/vim/addons/ftdetect'], ],
    }

    file { '/usr/sbin/batched_discard':
        ensure => present,
        source => 'puppet:///modules/anacron/batched_discard',
        owner  => 'root',
        group  => 'root',
        mode   => '550',
        before => Class['anacron'],
    }
    
    class { 'anacron':
        jobs => {
            'trim_ssd' => {
                command => '/usr/sbin/batched_discard',
                comment => 'weekly trim',
                delay   => 5,
                period  => '@weekly',
            }
        }
    }

    class { 'apt':
        update_timeout => 300,
    }

    apt::source { 'puppetlabs':
        location   => 'http://apt.puppetlabs.com',
        repos      => 'main dependencies',
        key        => '4BD6EC30',
        key_server => 'pgp.mit.edu',
	pin        => 400,
    }
}
