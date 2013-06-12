dbag = Chef::EncryptedDataBagItem.load "ENCRYPTED_DATABAG", "DATABAGITEM"

Chef::Log.info "foo key == #{dbag['foo']}"
