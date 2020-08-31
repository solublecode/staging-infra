output "servers_private" {
    value = digitalocean_droplet.server.*.ipv4_address_private
}

output "client_private" {
    value = concat(digitalocean_droplet.client-01.*.ipv4_address_private, [digitalocean_droplet.client-02.ipv4_address_private])
}

output "bastion_fqdn" {
    value = digitalocean_record.bastion.fqdn
}

output "cockpit_fqdn" {
    value = digitalocean_record.cockpit.fqdn
}

output "nginx_ui_fqdn" {
    value = digitalocean_record.nginx-ui.fqdn
}
