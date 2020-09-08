resource "digitalocean_droplet" "server" {
    count      = var.server_droplet_count
    image      = var.ubuntu-image 
    name       = "socrates-0${count.index + 1}"
    region     = var.region
    size       = var.server_droplet_size
    ssh_keys   = [data.digitalocean_ssh_key.main.id]
    vpc_uuid   = digitalocean_vpc.mapesa.id
    tags       = ["solublecode", "server"]
    user_data  = file("cloud-init/ubuntu-user-data.yaml")
    monitoring = true

    lifecycle {
        create_before_destroy = true
    }

    connection {
        type                 = "ssh"
        user                 = "root"
        host                 = self.ipv4_address_private
        timeout              = "10m"
        private_key          = var.ssh_private_key
        bastion_user         = "root"
        bastion_host         = digitalocean_droplet.bastion.ipv4_address
        bastion_private_key  = var.ssh_private_key
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 180",
            "apt install unzip",
            "mkdir -p /root/consul/data/server",
        ]
    }
    # ~~~~~~~~~~~~~~ #
    # Install Consul #
    # ~~~~~~~~~~~~~~ #
    provisioner "file" {
        source      = "${path.root}/scripts/consul/install_consul.sh"
        destination = "/tmp/install_consul.sh"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/server/consul-server.json"
        destination = "/root/consul/consul-server.json"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/server/consul-server.service"
        destination = "/etc/systemd/system/consul-server.service"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_consul.sh",
            "sed -i 's/__SERVER_NAME__/consul-server-0${count.index + 1}/g' /root/consul/consul-server.json",
            "sed -i 's/__CLUSTER_SIZE__/${var.server_droplet_count}/g' /root/consul/consul-server.json",
            "sed -i 's/__SERVER_IP_PRV__/${self.ipv4_address_private}/g' /root/consul/consul-server.json",
            "/tmp/install_consul.sh server",
        ]
    }
    provisioner "remote-exec" {
        inline = [
            "consul join ${digitalocean_droplet.server.0.ipv4_address_private}",
        ]
    }

    # ~~~~~~~~~~~~~ #
    # Install Vault #
    # ~~~~~~~~~~~~~ #
    // provisioner "file" {
    //     source      = "${path.root}/scripts/vault/install_vault.sh"
    //     destination = "/tmp/install_vault.sh"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/vault/vault.hcl"
    //     destination = "/root/vault/vault.hcl"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/vault/vault.service"
    //     destination = "/etc/systemd/system/vault.service"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/vault/setup_vault.sh"
    //     destination = "/tmp/setup_vault.sh"
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "chmod +x /tmp/install_vault.sh",
    //         "export VAULT_ADDR=http://127.0.0.1:8200",
    //         "/tmp/install_vault.sh",
    //     ]
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "chmod +x /tmp/setup_vault.sh",
    //         "export VAULT_ADDR=http://127.0.0.1:8200",
    //         "/tmp/setup_vault.sh ${count.index}",
    //     ]
    // }

    # ~~~~~~~~~~~~~ #
    # Install Nomad #
    # ~~~~~~~~~~~~~ #
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/install_nomad.sh"
    //     destination = "/tmp/install_nomad.sh"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.hcl"
    //     destination = "/root/nomad/nomad.hcl"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.service"
    //     destination = "/etc/systemd/system/nomad.service"
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "chmod +x /tmp/install_nomad.sh",
    //         "sed -i 's/__NOMAD_SERVER_IP_PRV__/${self.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__SERVER_IP_PRV__/${self.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__CLUSTER_SIZE__/${var.server_droplet_count}/g' /root/nomad/nomad.hcl",
    //         "/tmp/install_nomad.sh",
    //     ]
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "export NOMAD_ADDR=http://${digitalocean_droplet.server.0.ipv4_address_private}:4646",
    //         "nomad server join ${digitalocean_droplet.server.0.ipv4_address_private}",
    //     ]
    // }

}

resource "digitalocean_droplet" "client-01" {
    count      = var.client_droplet_count
    image      = var.ubuntu-image 
    name       = "plato-0${count.index + 1}"
    region     = var.region
    size       = var.client_droplet_size
    ssh_keys   = [data.digitalocean_ssh_key.main.id]
    vpc_uuid   = digitalocean_vpc.mapesa.id
    tags       = ["solublecode", "client"]
    user_data  = file("cloud-init/ubuntu-user-data.yaml")
    monitoring = true

    lifecycle {
        create_before_destroy = true
    }

    connection {
        type                 = "ssh"
        user                 = "root"
        host                 = self.ipv4_address_private
        timeout              = "10m"
        private_key          = var.ssh_private_key
        bastion_user         = "root"
        bastion_host         = digitalocean_droplet.bastion.ipv4_address
        bastion_private_key  = var.ssh_private_key
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 180",
            "apt install unzip",
            "mkdir -p /root/consul/data/client",
        ]
    }
    # ~~~~~~~~~~~~~~ #
    # Install Consul #
    # ~~~~~~~~~~~~~~ #
    provisioner "file" {
        source      = "${path.root}/scripts/consul/install_consul.sh"
        destination = "/tmp/install_consul.sh"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/client/consul-client.json"
        destination = "/root/consul/consul-client.json"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/client/consul-client.service"
        destination = "/etc/systemd/system/consul-client.service"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_consul.sh",
            "sed -i 's/__CLIENT_NAME__/consul-client-0${count.index + 1}/g' /root/consul/consul-client.json",
            "sed -i 's/__CLIENT_IP_PRV__/${self.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER01_IP_PRV__/${digitalocean_droplet.server.0.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER02_IP_PRV__/${digitalocean_droplet.server.1.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER03_IP_PRV__/${digitalocean_droplet.server.2.ipv4_address_private}/g' /root/consul/consul-client.json",
            "/tmp/install_consul.sh",
        ]
    }

    # ~~~~~~~~~~~~~ #
    # Install Nomad #
    # ~~~~~~~~~~~~~ #
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/install_nomad.sh"
    //     destination = "/tmp/install_nomad.sh"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.hcl"
    //     destination = "/root/nomad/nomad.hcl"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.service"
    //     destination = "/etc/systemd/system/nomad.service"
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "chmod +x /tmp/install_nomad.sh",
    //         "sed -i 's/__NOMAD_SERVER_IP_PRV__/${digitalocean_droplet.server.0.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__SERVER_IP_PRV__/${self.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__CLUSTER_SIZE__/${var.client_droplet_count}/g' /root/nomad/nomad.hcl",
    //         "/tmp/install_nomad.sh",
    //     ]
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "export NOMAD_ADDR=http://${digitalocean_droplet.server.0.ipv4_address_private}:4646",
    //         "nomad server join ${digitalocean_droplet.server.0.ipv4_address_private}",
    //     ]
    // }
}

resource "digitalocean_droplet" "client-02" {
    image      = var.fedora-image 
    name       = "plato-03"
    region     = var.region
    size       = var.client_droplet_size
    ssh_keys   = [data.digitalocean_ssh_key.main.id]
    vpc_uuid   = digitalocean_vpc.mapesa.id
    tags       = ["solublecode", "client"]
    user_data  = file("cloud-init/fedora-user-data.yaml")
    monitoring = true

    lifecycle {
        create_before_destroy = true
    }

    connection {
        type                 = "ssh"
        user                 = "root"
        host                 = self.ipv4_address_private
        timeout              = "10m"
        private_key          = var.ssh_private_key
        bastion_user         = "root"
        bastion_host         = digitalocean_droplet.bastion.ipv4_address
        bastion_private_key  = var.ssh_private_key
    }

    provisioner "remote-exec" {
        inline = [
            "sleep 180",
            "apt install unzip",
            "mkdir -p /root/consul/data/client",
        ]
    }
    # ~~~~~~~~~~~~~~ #
    # Install Consul #
    # ~~~~~~~~~~~~~~ #
    provisioner "file" {
        source      = "${path.root}/scripts/consul/install_consul.sh"
        destination = "/tmp/install_consul.sh"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/client/consul-client.json"
        destination = "/root/consul/consul-client.json"
    }
    provisioner "file" {
        source      = "${path.root}/scripts/consul/client/consul-client.service"
        destination = "/etc/systemd/system/consul-client.service"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/install_consul.sh",
            "sed -i 's/__CLIENT_NAME__/consul-client-03/g' /root/consul/consul-client.json",
            "sed -i 's/__CLIENT_IP_PRV__/${self.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER01_IP_PRV__/${digitalocean_droplet.server.0.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER02_IP_PRV__/${digitalocean_droplet.server.1.ipv4_address_private}/g' /root/consul/consul-client.json",
            "sed -i 's/__SERVER03_IP_PRV__/${digitalocean_droplet.server.2.ipv4_address_private}/g' /root/consul/consul-client.json",
            "/tmp/install_consul.sh",
        ]
    }
    provisioner "remote-exec" {
        inline = [
            "consul join ${digitalocean_droplet.server.0.ipv4_address_private}",
        ]
    }

    # ~~~~~~~~~~~~~ #
    # Install Nomad #
    # ~~~~~~~~~~~~~ #
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/install_nomad.sh"
    //     destination = "/tmp/install_nomad.sh"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.hcl"
    //     destination = "/root/nomad/nomad.hcl"
    // }
    // provisioner "file" {
    //     source      = "${path.root}/scripts/nomad/nomad.service"
    //     destination = "/etc/systemd/system/nomad.service"
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "chmod +x /tmp/install_nomad.sh",
    //         "sed -i 's/__NOMAD_SERVER_IP_PRV__/${digitalocean_droplet.server.0.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__SERVER_IP_PRV__/${self.ipv4_address_private}/g' /root/nomad/nomad.hcl",
    //         "sed -i 's/__CLUSTER_SIZE__/${var.client_droplet_count}/g' /root/nomad/nomad.hcl",
    //         "/tmp/install_nomad.sh",
    //     ]
    // }
    // provisioner "remote-exec" {
    //     inline = [
    //         "export NOMAD_ADDR=http://${digitalocean_droplet.server.0.ipv4_address_private}:4646",
    //         "nomad server join ${digitalocean_droplet.server.0.ipv4_address_private}",
    //     ]
    // }
}

resource "digitalocean_certificate" "mapesa" {
    name    = "${var.name}-certificate"
    type    = "lets_encrypt"
    domains = ["${var.subdomain}.${data.digitalocean_domain.mapesa.name}"]

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_loadbalancer" "mapesa" {
    name                   = "mapesa-${var.region}-lb"
    region                 = var.region
    droplet_ids            = concat(digitalocean_droplet.server.*.id, digitalocean_droplet.client-01.*.id, [digitalocean_droplet.client-02.id])
    vpc_uuid               = digitalocean_vpc.mapesa.id
    redirect_http_to_https = true
    
    forwarding_rule {
        entry_port      = 443
        entry_protocol  = "https"

        target_port     = 443
        target_protocol = "https"

        certificate_id  = digitalocean_certificate.mapesa.id
    }

    forwarding_rule {
        entry_port      = 80
        entry_protocol  = "http"

        target_port     = 80
        target_protocol = "http"

        certificate_id  = digitalocean_certificate.mapesa.id
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "digitalocean_firewall" "mapesa" {

    name        = "${var.name}-vpc-traffic"
    droplet_ids = concat(digitalocean_droplet.server.*.id, digitalocean_droplet.client-01.*.id, [digitalocean_droplet.client-02.id])

    inbound_rule {
        protocol         = "tcp"
        port_range       = "1-65535"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    inbound_rule {
        protocol         = "udp"
        port_range       = "1-65535"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    inbound_rule {
        protocol         = "icmp"
        source_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol              = "udp"
        port_range            = "1-65535"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }

    outbound_rule {
        protocol              = "icmp"
        destination_addresses = [digitalocean_vpc.mapesa.ip_range]
    }


    # DNS
    outbound_rule {
        protocol              = "udp"
        port_range            = "53"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTP
    outbound_rule {
        protocol              = "tcp"
        port_range            = "80"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTPS
    outbound_rule {
        protocol              = "tcp"
        port_range            = "443"
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
    ttl    = 30
}
