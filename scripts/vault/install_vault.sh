#! /bin/bash

echo "Installing Vault on server\n"

export VAULT_ADDR=http://127.0.0.1:8200
# Start install of vault
wget https://releases.hashicorp.com/vault/1.5.2/vault_1.5.2_linux_amd64.zip
unzip vault_1.5.2_linux_amd64.zip -d /usr/local/bin

# Start vault as a service
systemctl enable vault-server.service
systemctl start vault-server.service

echo "Installation of Vault complete\n"
exit 0
