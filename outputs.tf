output "servers_private" {
    value = digitalocean_droplet.server.*.ipv4_address_private
}

output "client_private" {
    value = concat(digitalocean_droplet.client-01.*.ipv4_address_private, [digitalocean_droplet.client-02.ipv4_address_private])
}

output "web_loadbalancer_fqdn" {
    value = digitalocean_record.mapesa.fqdn
}

output "bastion_fqdn" {
    value = digitalocean_record.bastion.fqdn
}
