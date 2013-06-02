for version in 11.2.0 11.4.4; do
  echo "****** Testing $version ******"
  vagrant destroy -f
  vagrant up
  vagrant ssh -c "sudo sh -c 'cd /vagrant && ./test_chef_data_bags.sh $version'"
  echo ""
done
