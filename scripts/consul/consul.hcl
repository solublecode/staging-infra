datacenter       = "solublecode-dc01"
bind_addr        = "__SERVER_IP_PRV__"
data_dir         = "/root/consul/data"
server           = true
bootstrap_expect = __CLUSTER_SIZE__
ui               = true
retry_join       = ["__SERVER_IP_PRV__"]
