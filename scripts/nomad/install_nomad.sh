#! /bin/bash

sleep 200 # wait for cloud-init

echo "Installing Nomad on server\n"

# Install nomad
wget https://releases.hashicorp.com/nomad/0.12.3/nomad_0.12.3_linux_amd64.zip
unzip nomad_0.12.3_linux_amd64.zip -d /usr/local/bin

sed -i 's/__SERVER_IP_PRV__/'$PRIVATE_IP'/g' /etc/nomad.d/nomad.hcl
sed -i 's/__CLUSTER_SIZE__/3/g' /etc/nomad.d/nomad.hcl

# Start nomad as a service
systemctl enable nomad.service
systemctl start nomad.service
echo "Installation of Nomad complete"
exit 0
