provider "digitalocean" {
  token = var.do_token
}


module "server-droplet" {
  source = "./modules/server-droplet"
  ssh_fingerprint = var.ssh_fingerprint
  server_droplet_region = var.droplet_region
  server_droplet_count = var.server_droplet_count
  server_droplet_size = var.server_droplet_size
}

module "client-droplet" {
  source = "./modules/client-droplet"
  ssh_fingerprint = var.ssh_fingerprint
  client_droplet_region = var.droplet_region
  client_droplet_count = var.client_droplet_count
  client_droplet_size = var.client_droplet_size
}
