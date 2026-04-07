logical_product_family  = "launch"
logical_product_service = "terratest"
class_env               = "sandbox"
instance_env            = 1
instance_resource       = 2

resource_names_map = {
  hosted_zone = {
    name       = "r53zone1"
    max_length = 40
  }
  record = {
    name       = "r53rec1"
    max_length = 24
  }
}

tags = {
  Example = "latency-routing"
}

type    = "A"
ttl     = 300
records = ["192.0.2.1"]

alias                            = null
set_identifier                   = "latency-us-east-1"
health_check_id                  = null
allow_overwrite                  = false
multivalue_answer_routing_policy = null
weighted_routing_policy          = null
failover_routing_policy          = null
geolocation_routing_policy       = null
geoproximity_routing_policy      = null
latency_routing_policy = {
  region = "us-east-1"
}
cidr_routing_policy = null
timeouts            = null
zone_id             = null
name                = null
