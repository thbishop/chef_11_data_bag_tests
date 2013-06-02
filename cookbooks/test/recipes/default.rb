Chef::Log.info data_bag("DATABAG").inspect
Chef::Log.info data_bag_item("DATABAG", "DATABAGITEM").inspect

dbag = data_bag_item("DATABAG", "DATABAGITEM")
Chef::Log.info "foo key == #{dbag['foo']}"
