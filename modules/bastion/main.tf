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