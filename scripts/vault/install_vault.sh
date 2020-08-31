#! /bin/bash

sleep 200 # wait for cloud-init

echo "Installing Vault on server"

export VAULT_ADDR=http://127.0.0.1:8200
# Start install of vault
wget https://releases.hashicorp.com/vault/1.5.2/vault_1.5.2_linux_amd64.zip
unzip vault_1.5.2_linux_amd64.zip -d /usr/local/bin

# Setup autocomplete
vault -autocomplete-install
complete -C /usr/local/bin/vault vault

sed -i 's/__SERVER_IP_PRV__/'$PRIVATE_IP'/g' /etc/vault.d/vault.hcl

# Start vault as a service
systemctl enable vault.service
systemctl start vault.service
echo "Installation of Vault complete"
exit 0