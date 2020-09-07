log_level  = "DEBUG"
data_dir   = "/root/nomad/data"
bind_addr  = "__SERVER_IP_PRV__"
datacenter = "solublecode-dc01"
log_level  = "DEBUG"
# Enable the server
server {
  enabled = true

  # Self-elect, should be 3 or 5 for production
  bootstrap_expect = __CLUSTER_SIZE__
}

# Enable a client on the same node
client {
  enabled = true
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

acl {
  enabled = true
}

consul {
  address             = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
}

telemetry {
  collection_interval        = "1s"
  disable_hostname           = true
  prometheus_metrics         = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}