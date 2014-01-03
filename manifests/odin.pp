
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
