# Validation-only tests — no AWS provider needed (mock provider).
# These exercise variable validations and lifecycle preconditions.

mock_provider "aws" {}

# --- Positive: simple A record ---
run "simple_a_record" {
  command = plan

  variables {
    zone_id = "Z0000000000000"
    name    = "www"
    type    = "A"
    ttl     = 300
    records = ["192.0.2.1"]
  }
}

# --- Positive: alias record without ttl/records ---
run "alias_record" {
  command = plan

  variables {
    zone_id = "Z0000000000000"
    name    = "www"
    type    = "A"
    alias = {
      name                   = "dualstack.elb.amazonaws.com"
      zone_id                = "Z0000000000001"
      evaluate_target_health = true
    }
  }
}

# --- Positive: geolocation with country + subdivision ---
run "geolocation_country_and_subdivision" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "us-ca"
    geolocation_routing_policy = {
      country     = "US"
      subdivision = "CA"
    }
  }
}

# --- Negative: geolocation subdivision without country ---
run "geolocation_subdivision_without_country" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "ca-only"
    geolocation_routing_policy = {
      subdivision = "CA"
    }
  }

  expect_failures = [
    var.geolocation_routing_policy,
  ]
}

# --- Negative: alias with ttl set ---
run "alias_with_ttl_fails" {
  command = plan

  variables {
    zone_id = "Z0000000000000"
    name    = "www"
    type    = "A"
    ttl     = 300
    alias = {
      name                   = "dualstack.elb.amazonaws.com"
      zone_id                = "Z0000000000001"
      evaluate_target_health = true
    }
  }

  expect_failures = [
    aws_route53_record.record,
  ]
}

# --- Negative: two routing policies (weighted + failover) ---
run "mutual_exclusion_two_policies" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "test"
    weighted_routing_policy = {
      weight = 100
    }
    failover_routing_policy = {
      type = "PRIMARY"
    }
  }

  expect_failures = [
    aws_route53_record.record,
  ]
}

# --- Positive: single routing policy (weighted only) ---
run "single_routing_policy_weighted" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "weighted-1"
    weighted_routing_policy = {
      weight = 70
    }
  }
}

# --- Negative: invalid DNS type ---
run "invalid_dns_type" {
  command = plan

  variables {
    zone_id = "Z0000000000000"
    name    = "www"
    type    = "INVALID"
    ttl     = 300
    records = ["192.0.2.1"]
  }

  expect_failures = [
    var.type,
  ]
}

# --- Negative: TTL out of range ---
run "ttl_out_of_range" {
  command = plan

  variables {
    zone_id = "Z0000000000000"
    name    = "www"
    type    = "A"
    ttl     = -1
    records = ["192.0.2.1"]
  }

  expect_failures = [
    var.ttl,
  ]
}

# --- Negative: weighted routing weight out of range ---
run "weighted_routing_weight_out_of_range" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "test"
    weighted_routing_policy = {
      weight = 300
    }
  }

  expect_failures = [
    var.weighted_routing_policy,
  ]
}

# --- Negative: failover type invalid ---
run "failover_type_invalid" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "test"
    failover_routing_policy = {
      type = "TERTIARY"
    }
  }

  expect_failures = [
    var.failover_routing_policy,
  ]
}

# --- Negative: geoproximity bias out of range ---
run "geoproximity_bias_out_of_range" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "test"
    geoproximity_routing_policy = {
      aws_region = "us-east-1"
      bias       = 100
    }
  }

  expect_failures = [
    var.geoproximity_routing_policy,
  ]
}

# --- Positive: geoproximity with valid bias ---
run "geoproximity_valid" {
  command = plan

  variables {
    zone_id        = "Z0000000000000"
    name           = "www"
    type           = "A"
    ttl            = 300
    records        = ["192.0.2.1"]
    set_identifier = "test"
    geoproximity_routing_policy = {
      aws_region = "us-east-1"
      bias       = 50
    }
  }
}
