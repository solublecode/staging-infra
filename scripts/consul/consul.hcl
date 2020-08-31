datacenter       = "solublecode-dc01"
bind_addr        = "__SERVER_IP_PRV__"
data_dir         = "/root/consul"
encrypt          = "bjZ2b2tSUENMT0tvVmZ4OXZYb3NTVjI1by9xTUJ5dS9sNk42eFIvdzBBWT0K"
server           = true
bootstrap_expect = __CLUSTER_SIZE__
ui               = true
retry_join       = ["__SERVER_IP_PRV__"]
