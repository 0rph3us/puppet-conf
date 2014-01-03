puppet configuration from 0rph3us
=================================


puppet apply --verbose  --modulepath=/etc/puppet/modules:/home/rennecke/git/my-puppet-conf/modules --manifestdir /home/rennecke/git/my-puppet-conf/manifests --detailed-exitcodes /home/rennecke/git/my-puppet-conf/manifests/odin.pp || [ $? -eq 2 ]
