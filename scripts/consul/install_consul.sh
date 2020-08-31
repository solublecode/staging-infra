#! /bin/bash

sleep 200 # wait for cloud-init

echo "Installing Consul on server"

# Start install of consul and setup
wget https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip
unzip consul_1.8.3_linux_amd64.zip -d /usr/local/bin
rm -rf consul_1.8.3_linux_amd64.zip

# Setup autocomplete
consul -autocomplete-install
complete -C /usr/local/bin/consul consul


sed -i 's/__SERVER_IP_PRV__/'$PRIVATE_IP'/g' /etc/consul.d/consul.hcl
sed -i 's/__CLUSTER_SIZE__/3/g' /etc/consul.d/consul.hcl

# Start consul as a service
systemctl enable consul.service
systemctl start consul.service
echo "Installation of Consul complete"
exit 0
