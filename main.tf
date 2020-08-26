provider "digitalocean" {
  token = var.do_token
}


module "server" {
  source = "./modules/server"
  ssh_fingerprint = var.ssh_fingerprint
  server_droplet_region = var.droplet_region
  server_droplet_count = var.server_droplet_count
  server_droplet_size = var.server_droplet_size
  ssh_private_key = var.ssh_private_key
}

module "client" {
  source = "./modules/client"
  ssh_fingerprint = var.ssh_fingerprint
  client_droplet_region = var.droplet_region
  client_droplet_count = var.client_droplet_count
  client_droplet_size = var.client_droplet_size
  ssh_private_key = var.ssh_private_key
}

module "bastion" {
  source = "./modules/bastion"
  ssh_fingerprint = var.ssh_fingerprint
  bastion_droplet_region = var.droplet_region
  bastion_droplet_size = var.bastion_droplet_size
  ssh_private_key = var.ssh_private_key
}
