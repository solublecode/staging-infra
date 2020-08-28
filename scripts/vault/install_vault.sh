#! /bin/bash

echo "Installing Vault on server\n"

# Start install of vault
wget https://releases.hashicorp.com/vault/1.5.2/vault_1.5.2_linux_amd64.zip
unzip vault_1.5.2_linux_amd64.zip -d /usr/bin/

mkdir -p $HOME/vault
# Start vault as a service
systemctl enable vault-server.service
systemctl start vault-server.service

echo "Installation of Vault complete\n"
exit 0
