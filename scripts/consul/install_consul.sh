#! /bin/bash

sleep 180 # wait for cloud-init

echo "Installing Consul on server\n"

mkdir /etc/consul.d

# Setup iptables to allow access to localhost from docker
sysctl -w net.ipv4.conf.docker0.route_localnet=1
iptables -t nat -I PREROUTING -i docker0 -d 172.17.0.1 -p tcp -j DNAT --to 127.0.0.1
iptables -t filter -I INPUT -i docker0 -d 127.0.0.1 -p tcp -j ACCEPT

# Start install of consul and setup
wget https://releases.hashicorp.com/consul/1.8.3/consul_1.8.3_linux_amd64.zip
unzip consul_1.8.3_linux_amd64.zip -d /usr/local/bin
rm -rf consul_1.8.3_linux_amd64.zip

# Install of consul-template and setup
wget https://releases.hashicorp.com/consul-template/0.25.1/consul-template_0.25.1_linux_amd64.zip
unzip consul-template_0.25.1_linux_amd64.zip -d /usr/local/bin
rm -rf consul-template_0.25.1_linux_amd64.zip

# Start consul as a service
if [ $1 == "server" ]; then
	systemctl enable consul-server.service
	systemctl start consul-server.service
else
	systemctl enable consul-client.service
	systemctl start consul-client.service
  	sleep 10
	consul join $3
fi
echo "Installation of Consul complete\n"
exit 0
