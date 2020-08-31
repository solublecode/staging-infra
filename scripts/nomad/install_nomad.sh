#! /bin/bash

echo "Installing Nomad on server\n"

# Install nomad
wget https://releases.hashicorp.com/nomad/0.12.3/nomad_0.12.3_linux_amd64.zip
unzip nomad_0.12.3_linux_amd64.zip -d /usr/local/bin

local vaultToken=`grep "Initial Root Token" /root/startupOutput.txt | cut -d' ' -f4`
sed -i "s/PLEASE_FILL_TOKEN/${vaultToken}/g" /root/nomad.hcl

# Start nomad as a service
systemctl enable nomad.service
systemctl start nomad.service
echo "Installation of Nomad complete"
exit 0
