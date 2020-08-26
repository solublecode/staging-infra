resource "digitalocean_vpc" "mapesa"{
    name = "${var.name}-vpc"
    region = var.region
}