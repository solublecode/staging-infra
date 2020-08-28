variable do_token {
    type = string
}

variable region {
    type = string
    default = "ams3"
}

variable server_droplet_count {
    type = number
    default = 3
}

variable client_droplet_count {
    type = number
    default = 2
}

variable server_droplet_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable client_droplet_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable bastion_droplet_size {
    type = string
    default = "s-1vcpu-1gb"
}

variable ssh_key {
    type = string
    description = "Name of SSH Key as it appears in the DigitalOcean dashboard"
}

variable ssh_private_key {
    type = string
    description = "PRIVATE key"
}

variable subdomain {
    type = string
    description = "The first part of my URL. Ex: the www in www.solublecode.dev"
    default = "apollo"
}

variable domain_name {
    type = string
    description = "Domain you have registered and manged by DigitalOcean"
    default = "solublecode.dev"
}

variable name {
    type = string
    default = "mapesa"
    description = "Name of your project. Will be prepended to most resources"
}

# https://slugs.do-api.dev/
variable ubuntu-image {
    type = string
    default = "ubuntu-20-04-x64"
}

variable fedora-image {
    type = string
    default = "fedora-31-x64"
}

variable centos-image {
    type = string
    default = "centos-8-x64"
}