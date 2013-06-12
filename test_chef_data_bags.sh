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
KNIFE_CMD="/opt/chef/bin/knife solo data bag create"

rpm -ivh $BASE_RPM_URL/chef-$CHEF_VERSION.el6.x86_64.rpm

/opt/chef/embedded/bin/gem install knife-solo_data_bag --no-rdoc --no-ri

cd /vagrant

rm -rf data_bags
mkdir data_bags

if [ "$ENCRYPT_DATA_BAGS" == "yes" ]; then
  CHEF_RECIPE="test::encrypted"
  SECRET=foo

  mkdir /etc/chef
  echo $SECRET > /etc/chef/encrypted_data_bag_secret

  $KNIFE_CMD ENCRYPTED_DATABAG DATABAGITEM \
    --json '{ "id": "DATABAGITEM", "foo": "my_secret" }' \
    --data-bag-path data_bags/ -s $SECRET

  echo ""
  echo "Data bag contents:"
  cat data_bags/ENCRYPTED_DATABAG/DATABAGITEM.json
  echo ""
  echo ""
else
  CHEF_RECIPE="test"

  $KNIFE_CMD DATABAG DATABAGITEM \
    --json '{ "id": "DATABAGITEM", "foo": "bar" }' \
    --data-bag-path data_bags/ $DATA_BAG_ENCRYPT_OPTION

  echo ""
  echo "Data bag contents:"
  cat data_bags/DATABAG/DATABAGITEM.json
  echo ""
  echo ""
fi

chef-solo -o "recipe[$CHEF_RECIPE]" -c config.rb -l info
