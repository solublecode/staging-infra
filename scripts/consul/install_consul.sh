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
if [ $1 == "server" ]; then
    systemctl enable consul-server.service
    systemctl start consul-server.service
else
    systemctl enable consul-client.service
    systemctl start consul-client.service
fi
echo "Installation of Consul complete"
exit 0
