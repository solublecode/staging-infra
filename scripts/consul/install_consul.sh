#! /bin/bash

echo "Installing Consul on server"

# Start install of consul and setup
wget https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip
unzip consul_1.8.3_linux_amd64.zip -d /usr/local/bin
rm consul_1.8.3_linux_amd64.zip

# Start install of consul-template and setup
wget https://releases.hashicorp.com/consul-template/0.25.1/consul-template_0.25.1_linux_amd64.zip
unzip consul-template_0.25.1_linux_amd64.zip -d /usr/local/bin

# Setup autocomplete
consul -autocomplete-install
complete -C /usr/local/bin/consul consul

# Start consul as a service
if [ $1 == "server" ]; then
    systemctl enable --now consul-server.service
else
    systemctl enable --now consul-client.service
fi
echo "Installation of Consul complete"
exit 0
