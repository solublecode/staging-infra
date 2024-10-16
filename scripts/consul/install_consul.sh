#! /bin/bash

echo "Installing Consul on server"

# Start install of consul and setup
wget https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip
unzip consul_1.8.3_linux_amd64.zip -d /usr/local/bin
rm consul_1.8.3_linux_amd64.zip

# Setup autocomplete
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

# Start consul as a service
systemctl enable consul.service
systemctl start consul.service
echo "Installation of Consul complete"
exit 0
