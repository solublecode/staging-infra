provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_ssh_key" "solublecode" {
  name       = "SolubleCode@JARVIS"
  public_key = file("/Users/collin/.ssh/apollo.pub")
}

module "server-droplet" {
  source = "./modules/server-droplet"
  ssh_key_fingerprint = digitalocean_ssh_key.solublecode.fingerprint
  server_droplet_region = var.droplet_region
  server_droplet_count = var.server_droplet_count
  server_droplet_size = var.server_droplet_size
}

module "client-droplet" {
  source = "./modules/client-droplet"
  ssh_key_fingerprint = digitalocean_ssh_key.solublecode.fingerprint
  client_droplet_region = var.droplet_region
  client_droplet_count = var.client_droplet_count
  client_droplet_size = var.client_droplet_size
}
