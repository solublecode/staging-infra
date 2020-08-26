resource "digitalocean_droplet" "server" {
    count = var.server_droplet_count
    image = var.ubuntu-image 
    name = "socrates-${var.name}-0${count.index + 1}"
    region = var.region
    size = var.server_droplet_size
    ssh_keys = [data.digitalocean_ssh_key.main.id]
    vpc_uuid = digitalocean_vpc.mapesa.id
    tags = ["solublecode", "server"]
    user_data = file("cloud-init/user-data.yaml")

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_droplet" "client-01" {
    count = var.client_droplet_count
    image = var.ubuntu-image 
    name = "plato-${var.name}-0${count.index + 1}"
    region = var.region
    size = var.client_droplet_size
    ssh_keys = [data.digitalocean_ssh_key.main.id]
    vpc_uuid = digitalocean_vpc.mapesa.id
    tags = ["solublecode", "client"]
    user_data = file("cloud-init/user-data.yaml")

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_droplet" "client-02" {
    image = var.fedora-image 
    name = "plato-${var.name}-03"
    region = var.region
    size = var.client_droplet_size
    ssh_keys = [data.digitalocean_ssh_key.main.id]
    vpc_uuid = digitalocean_vpc.mapesa.id
    tags = ["solublecode", "client"]
    user_data = file("cloud-init/user-data.yaml")

    lifecycle {
        create_before_destroy = true
    }
}


resource "digitalocean_certificate" "mapesa" {
    name = "${var.name}-certificate"
    type = "lets_encrypt"
    domains = ["${var.subdomain}.${data.digitalocean_domain.mapesa.name}"]
    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_loadbalancer" "mapesa" {
    name = "mapesa-${var.region}-lb"
    region = var.region
    droplet_ids = concat(digitalocean_droplet.server.*.id, digitalocean_droplet.client-01.*.id)
    vpc_uuid = digitalocean_vpc.mapesa.id
    redirect_http_to_https = true
    
    forwarding_rule {
        entry_port = 443
        entry_protocol = "https"

        target_port = 80
        target_protocol = "http"

        certificate_id = digitalocean_certificate.mapesa.id
    }

    forwarding_rule {
        entry_port = 80
        entry_protocol = "http"

        target_port = 80
        target_protocol = "http"

        certificate_id = digitalocean_certificate.mapesa.id
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_firewall" "mapesa" {

    name = "${var.name}-only-vpc-traffic"
    droplet_ids = concat(digitalocean_droplet.server.*.id, digitalocean_droplet.client-01.*.id, digitalocean_droplet.client-02.id)

    inbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    inbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    inbound_rule {
        protocol = "icmp"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol = "icmp"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }


    # DNS
    outbound_rule {
        protocol = "udp"
        port_range = "53"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTP
    outbound_rule {
        protocol = "tcp"
        port_range = "80"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTPS
    outbound_rule {
        protocol = "tcp"
        port_range = "443"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # ICMP (Ping)
    outbound_rule {
        protocol              = "icmp"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}

resource "digitalocean_record" "mapesa" {
    domain = data.digitalocean_domain.mapesa.name
    type   = "A"
    name   = var.subdomain
    value  = digitalocean_loadbalancer.mapesa.ip
    ttl    = 1800
}
