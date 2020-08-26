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


  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-get install docker-ce docker-ce-cli containerd.io",
      "sudo apt install default-jdk",
    ]

    connection {
      type     = "ssh"
      user     = "root"
      timeout  = "2m"
    }
  }
}

resource "digitalocean_droplet" "client-02" {
  image  = "fedora-31-x64"
  region = var.client_droplet_region
  size   = "s-2vcpu-4gb"
  name   = "plato-03"
  ssh_keys = ["${var.ssh_fingerprint}"]
  private_networking = true
  tags = ["solublecode", "client"]


  provisioner "remote-exec" {
    inline = [
      "sudo dnf -y install dnf-plugins-core",
      "sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo",
      "sudo dnf install docker-ce docker-ce-cli containerd.io",
      "sudo dnf install java-latest-openjdk.x86_64",
    ]

    connection {
      type     = "ssh"
      user     = "root"
      timeout  = "2m"
    }
  }
}
