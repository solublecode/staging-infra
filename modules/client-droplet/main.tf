variable "ssh_fingerprint" {}
variable "client_droplet_size" {}
variable "client_droplet_count" {}
variable "client_droplet_region" {}

resource "digitalocean_droplet" "client-01" {
  image  = "ubuntu-18-04-x64"
  count  = var.client_droplet_count
  region = var.client_droplet_region
  size   = var.client_droplet_size
  name   = "plato-0${count.index + 1}"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "client"]
}

resource "digitalocean_droplet" "client-02" {
  image  = "ubuntu-18-04-x64"
  region = var.client_droplet_region
  size   = "s-2vcpu-4gb"
  name   = "plato-03"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "client"]
}
