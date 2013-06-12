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

BASE_RPM_URL=https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64
rpm -ivh $BASE_RPM_URL/chef-$CHEF_VERSION.el6.x86_64.rpm

/opt/chef/embedded/bin/gem install knife-solo_data_bag --no-rdoc --no-ri

cd /vagrant

rm -f data_bags/DATABAG/DATABAGITEM.json

if [ "$ENCRYPT_DATA_BAGS" == "yes" ]; then
  echo "Going to encrypt the data bag"
  CHEF_RECIPE="test::encrypted"
  DATA_BAG_ENCRYPT_OPTION="-s foo"
  mkdir /etc/chef
  echo foo > /etc/chef/encrypted_data_bag_secret
else
  CHEF_RECIPE="test"
  DATA_BAG_ENCRYPT_OPTION=""
fi

/opt/chef/bin/knife solo data bag create DATABAG DATABAGITEM \
  --json '{ "id": "DATABAGITEM", "foo": "bar" }' \
  --data-bag-path data_bags/ $DATA_BAG_ENCRYPT_OPTION

echo "Data bag contents:"
cat data_bags/DATABAG/DATABAGITEM.json

chef-solo -o "recipe[$CHEF_RECIPE]" -c config.rb -l info
