#!/bin/bash

if [ $# -eq 0 ] ; then
  echo 'Please pass the chef version to install'
  echo "Only '11.4.4' or '11.2.0' are supported values"
  exit 1
fi

case "$1" in
  "11.4.4") CHEF_VERSION="11.4.4-2" ;;
  "11.2.0") CHEF_VERSION="11.2.0-1" ;;
  *) echo 'Unknown Chef version'
     exit 1
     ;;
 esac

rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-$CHEF_VERSION.el6.x86_64.rpm

/opt/chef/embedded/bin/gem install knife-solo_data_bag --no-rdoc --no-ri

cd /vagrant

rm -f data_bags/DATABAG/DATABAGITEM.json

/opt/chef/bin/knife solo data bag create DATABAG DATABAGITEM --json '{ "id": "DATABAGITEM", "foo": "bar" }' --data-bag-path data_bags/

chef-solo -o 'recipe[test]' -c config.rb -l info


