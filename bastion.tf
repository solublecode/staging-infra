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

resource "digitalocean_firewall" "bastion" {
    name = "${var.name}-only-ssh-bastion"
    droplet_ids = [digitalocean_droplet.bastion.id]

    inbound_rule {
        protocol = "tcp"
        port_range = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "22"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol = "icmp"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }
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
    name   = "proxy"
    value  = digitalocean_droplet.bastion.ipv4_address
    ttl    = 1800
}