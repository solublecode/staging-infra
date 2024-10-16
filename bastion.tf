resource "digitalocean_droplet" "bastion" {
    image      = var.centos-image 
    name       = "bastion-${var.name}"
    region     = var.region
    size       = var.bastion_droplet_size
    ssh_keys   = [data.digitalocean_ssh_key.main.id]
    vpc_uuid   = digitalocean_vpc.mapesa.id
    tags       = ["solublecode", "bastion"]
    user_data  = file("cloud-init/centos-user-data.yaml")
    monitoring = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_record" "bastion" {
    domain = data.digitalocean_domain.mapesa.name
    type   = "A"
    name   = "sh"
    value  = digitalocean_droplet.bastion.ipv4_address
    ttl    = 1800
}

resource "digitalocean_record" "cockpit" {
    domain = data.digitalocean_domain.mapesa.name
    type   = "A"
    name   = "cockpit"
    value  = digitalocean_droplet.bastion.ipv4_address
    ttl    = 1800
}

resource "digitalocean_record" "nginx-ui" {
    domain = data.digitalocean_domain.mapesa.name
    type   = "A"
    name   = "nginx"
    value  = digitalocean_droplet.bastion.ipv4_address
    ttl    = 1800
}