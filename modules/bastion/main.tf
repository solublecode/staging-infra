variable "ssh_fingerprint" {}
variable "bastion_droplet_size" {}
variable "bastion_droplet_region" {}
variable "ssh_private_key" {}


resource "digitalocean_droplet" "bastion" {
  image  = "ubuntu-18-04-x64"
  region = var.bastion_droplet_region
  size   = var.bastion_droplet_size
  name   = "bastion"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "bastion"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      timeout     = "2m"
      host        = self.ipv4_address
      private_key = var.ssh_private_key
    }
  }
}

resource "digitalocean_floating_ip" "bastion" {
  region = var.bastion_droplet_region
}

resource "digitalocean_floating_ip_assignment" "bastion" {
  ip_address = digitalocean_floating_ip.bastion.id
  droplet_id = digitalocean_droplet.bastion.id
}

resource "digitalocean_firewall" "bastion" {
  name        = "bastion-fw"
  droplet_ids = [digitalocean_droplet.bastion.id]

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}