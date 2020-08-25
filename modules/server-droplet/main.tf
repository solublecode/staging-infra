variable "ssh_fingerprint" {}
variable "server_droplet_size" {}
variable "server_droplet_count" {}
variable "server_droplet_region" {}

resource "digitalocean_droplet" "server" {
  image  = "ubuntu-18-04-x64"
  count  = var.server_droplet_count
  region = var.server_droplet_region
  size   = var.server_droplet_size
  name   = "socrates-0${count.index + 1}"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "server"]
}