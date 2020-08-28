#! /bin/bash

jobName=$1
buildVersion=$2
serviceCount=$3
vaultToken=$4

export VAULT_TOKEN=${vaultToken}

# Put buildVersion and count in consul kv store
consul kv put "${jobName}-version" ${buildVersion}
consul kv put "${jobName}-count" ${serviceCount}

exit 0
