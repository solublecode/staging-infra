# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/root/nomad/client"

# Enable the client
client {
    enabled = true
    options = {
      "driver.raw_exec.enable" = "1"
    }
}

ports {
    http = 5657
}

consul {
  address             = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}
