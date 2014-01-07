node 'common' {
    include common
}

node /walhalla/ inherits 'common' {
    

#    udev::rule { 'hd_power_save.rules':
#	ensure  => present,
#	content => 'SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="min_power"',
#    }

    udev::rule { 'pci_pm.rules':
	ensure  => present,
	content => 'SUBSYSTEM=="pci", ATTR{power/control}="auto"',
    }

	notify{'done with walhalla':}

#    udev::rule { 'disable_wol.rules':
#	ensure  => present,
#	content => 'SUBSYSTEM=="net", KERNEL=="eth*", RUN+="/sbin/ethtool -s %k wol d"',
#	require => Package['ethtool'],
#    }
}

node /odin/ inherits 'common' {
    notify{'done with odin':}
}
