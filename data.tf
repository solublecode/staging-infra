data "digitalocean_ssh_key" "main" {
    name = var.ssh_key
}

data "digitalocean_domain" "mapesa" {
    name = var.domain_name
}