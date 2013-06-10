for version in 11.2.0 11.4.4; do
  for encrypt in yes no; do
    echo "****** Testing $version || Encrypted == $encrypt ******"
    vagrant destroy -f
    vagrant up
    vagrant ssh -c "sudo sh -c 'cd /vagrant && export ENCRYPT_DATA_BAGS=$encrypt && ./test_chef_data_bags.sh $version'"
    echo ""
  done
done
