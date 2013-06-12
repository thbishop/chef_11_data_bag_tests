dbag = Chef::EncryptedDataBagItem.load "ENCRYPTED_DATABAG", "DATABAGITEM"

Chef::Log.info "Inspect: #{dbag.inspect}"
Chef::Log.info ''
Chef::Log.info ''
Chef::Log.info "foo key == #{dbag['foo']}"
Chef::Log.info ''
Chef::Log.info ''
