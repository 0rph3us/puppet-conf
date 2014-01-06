puppet configuration from 0rph3us
=================================

r10k puppetfile install

puppet apply --verbose  --modulepath=/etc/puppet/modules:/home/rennecke/git/my-puppet-conf/modules --manifestdir /home/rennecke/git/my-puppet-conf/manifests --detailed-exitcodes /home/rennecke/git/my-puppet-conf/manifests/site.pp || [ $? -eq 2 ]

