#!/bin/bash

cp manifests/* /etc/puppet/manifests
cp Puppetfile /etc/puppet

cd /etc/puppet
r10k puppetfile install

puppet apply --verbose --detailed-exitcodes /etc/puppet/manifests/site.pp
