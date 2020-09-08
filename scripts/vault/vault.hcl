ui = true
api_addr = "http://127.0.0.1:8200"

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
}