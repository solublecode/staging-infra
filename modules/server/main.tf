variable "ssh_fingerprint" {}
variable "server_droplet_size" {}
variable "server_droplet_count" {}
variable "server_droplet_region" {}
variable "ssh_private_key" {}

resource "digitalocean_droplet" "server" {
  image  = "ubuntu-18-04-x64"
  count  = var.server_droplet_count
  region = var.server_droplet_region
  size   = var.server_droplet_size
  name   = "socrates-0${count.index + 1}"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "server"]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-get -y install docker-ce docker-ce-cli containerd.io",
      "sudo apt-get -y install default-jdk",
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