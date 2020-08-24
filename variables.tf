variable "do_token" {
    type = string
}

variable "droplet_region" {
    type = string
    default = "ams3"
}

variable "server_droplet_count" {
    default = 3
}

variable "client_droplet_count" {
    default = 2
}

variable "server_droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}

variable "client_droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}