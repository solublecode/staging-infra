#! /bin/bash

echo "Installing Nomad on server\n"

# Install nomad
wget https://releases.hashicorp.com/nomad/0.12.3/nomad_0.12.3_linux_amd64.zip
unzip nomad_0.12.3_linux_amd64.zip -d /usr/local/bin
rm -rf nomad_0.12.3_linux_amd64.zip

# Setup Vault Token
export VAULT_TOKEN=`grep "Initial Root Token" /root/startupOutput.txt | cut -d' ' -f4`
export IP_ADDR=`ifconfig eth0 | grep 'inet ' | sed 's/\s\s*/ /g' | cut -d' ' -f3 | awk '{ print $1}'`
sed -i 's/server_ip/'$IP_ADDR'/g' /root/nomad-server.hcl

# Start nomad as a service
if [ $1 == "server" ]; then
	systemctl enable nomad-server.service
	systemctl start nomad-server.service
else
	systemctl enable nomad-client.service
	systemctl start nomad-client.service
fi
echo "Installation of Nomad complete\n"
exit 0
