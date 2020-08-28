#! /bin/bash

jobName=$1
buildVersion=$2
serviceCount=$3
vaultToken=$4

nomadIp=`ifconfig eth0 | grep 'inet ' | sed 's/\s\s*/ /g' | cut -d' ' -f3 | awk '{ print $1}'`
export NOMAD_ADDR="http://${nomadIp}:4646"
export VAULT_TOKEN=${vaultToken}

# Put buildVersion and count in consul kv store
consul kv put "${jobName}-version" ${buildVersion}
consul kv put "${jobName}-count" ${serviceCount}

exit 0
