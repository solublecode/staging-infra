#! /bin/bash

echo "Installing Nomad on server\n"

# Install nomad
wget https://releases.hashicorp.com/nomad/0.12.3/nomad_0.12.3_linux_amd64.zip
unzip nomad_0.12.3_linux_amd64.zip -d /usr/local/bin
rm nomad_0.12.3_linux_amd64.zip

token=`grep "Initial Root Token" /root/vault/tokens.txt | cut -d' ' -f4`
sed -i 's/replace_vault_token/${token}/g' /etc/systemd/system/nomad.service

# Start nomad as a service
systemctl enable nomad.service
systemctl start nomad.service
echo "Installation of Nomad complete"
exit 0
