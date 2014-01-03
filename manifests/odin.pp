
node default {
    include stdlib
    
    $packages = [ 'ntp', 'htop', 'vim-puppet', 'puppet', 'puppet-common', 'ethtool']
    package { $packages: 
        ensure  => 'latest',
        require => Apt::Source['puppetlabs'],
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
                period  => 7,
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
	    pin        => 1000,
    }

#    udev::rule { 'hd_power_save.rules':
#	ensure  => present,
#	content => 'SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"',
#    }

    udev::rule { 'pci_pm.rules':
	ensure  => present,
	content => 'SUBSYSTEM=="pci", ATTR{power/control}="auto"',
    }

#    udev::rule { 'disable_wol.rules':
#	ensure  => present,
#	content => 'SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/sbin/ethtool -s %k wol d"',
#	require => Package['ethtool'],
#    }
}
