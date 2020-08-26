output "servers_private" {
    value = digitalocean_droplet.server.*.ipv4_address_private
}

output "client_private" {
    value = digitalocean_droplet.client-01.*.ipv4_address_private
}

output "web_loadbalancer_fqdn" {
    value = digitalocean_record.web.fqdn
}

output "bastion_fqdn" {
    value = digitalocean_record.bastion.fqdn
}
