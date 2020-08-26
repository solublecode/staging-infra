resource "digitalocean_vpc" "web"{
    name = "${var.name}-vpc"
    region = var.region
}