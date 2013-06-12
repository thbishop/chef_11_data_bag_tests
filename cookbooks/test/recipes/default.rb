dbag = data_bag_item("DATABAG", "DATABAGITEM")

Chef::Log.info "Inspect: #{dbag.inspect}"
Chef::Log.info ''
Chef::Log.info ''
Chef::Log.info "foo key == #{dbag['foo']}"
Chef::Log.info ''
Chef::Log.info ''
