# tf-aws-module_primitive-route53_record

Terraform primitive module for a single [`aws_route53_record`](https://registry.terraform.io/providers/hashicorp/aws/5.100.0/docs/resources/route53_record).

## Overview

This module wraps one Route 53 resource record set. It supports simple records (`ttl` + `records`), alias targets, and optional routing policies (weighted, failover, geolocation, geoproximity, latency, CIDR, multivalue answer).

## Usage

### Simple record

```hcl
module "www" {
  source = "path/to/module"

  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = ["203.0.113.10"]
}
```

### Complete example with routing policy

```hcl
module "www_latency" {
  source = "path/to/module"

  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300
  records = ["203.0.113.10"]

  set_identifier = "us-east-1"

  latency_routing_policy = {
    region = "us-east-1"
  }
}
```

See [`examples/complete`](examples/complete) for a full working example with all supported variables.

## Provider configuration

Configure the AWS provider in the root module. This repository’s `examples/complete` expects a generated `provider.tf` from the standard Makefile workflow.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.100 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | Alias target (e.g. ELB, CloudFront). When set, do not set ttl or records.<br/>The inner `name` is the DNS name to point to (e.g. load balancer DNS name). | <pre>object({<br/>    name                   = string<br/>    zone_id                = string<br/>    evaluate_target_health = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow overwriting an existing record set with the same name and type. | `bool` | `false` | no |
| <a name="input_cidr_routing_policy"></a> [cidr\_routing\_policy](#input\_cidr\_routing\_policy) | CIDR (IP-based) routing policy block. | <pre>object({<br/>    collection_id = string<br/>    location_name = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_failover_routing_policy"></a> [failover\_routing\_policy](#input\_failover\_routing\_policy) | Failover routing policy block. | <pre>object({<br/>    type = string<br/>  })</pre> | `null` | no |
| <a name="input_geolocation_routing_policy"></a> [geolocation\_routing\_policy](#input\_geolocation\_routing\_policy) | Geolocation routing policy block. | <pre>object({<br/>    continent   = optional(string)<br/>    country     = optional(string)<br/>    subdivision = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_geoproximity_routing_policy"></a> [geoproximity\_routing\_policy](#input\_geoproximity\_routing\_policy) | Geoproximity routing policy block. | <pre>object({<br/>    aws_region       = optional(string)<br/>    bias             = optional(number)<br/>    local_zone_group = optional(string)<br/>    coordinates = optional(list(object({<br/>      latitude  = string<br/>      longitude = string<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | Health check ID to associate with alias, weighted, or failover routing. | `string` | `null` | no |
| <a name="input_latency_routing_policy"></a> [latency\_routing\_policy](#input\_latency\_routing\_policy) | Latency routing policy block. | <pre>object({<br/>    region = string<br/>  })</pre> | `null` | no |
| <a name="input_multivalue_answer_routing_policy"></a> [multivalue\_answer\_routing\_policy](#input\_multivalue\_answer\_routing\_policy) | Set to true for multivalue answer routing. | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | DNS domain name for the record (relative to the zone or fully qualified). | `string` | n/a | yes |
| <a name="input_records"></a> [records](#input\_records) | String records for non-alias records (e.g. IPv4 for A, text for TXT). | `list(string)` | `null` | no |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | Unique identifier for weighted, latency, geolocation, or failover routing. | `string` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Create, update, and delete timeouts for the record set change. | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL of the record in seconds. Omit when using an alias record. | `number` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | DNS record type. | `string` | n/a | yes |
| <a name="input_weighted_routing_policy"></a> [weighted\_routing\_policy](#input\_weighted\_routing\_policy) | Weighted routing policy block. | <pre>object({<br/>    weight = number<br/>  })</pre> | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The ID of the hosted zone that contains this resource record set. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN built from the record name and zone (trailing dot omitted). |
| <a name="output_id"></a> [id](#output\_id) | The Route 53 record set ID (hosted zone ID, record name, and type). |
| <a name="output_name"></a> [name](#output\_name) | The name of the record. |
| <a name="output_type"></a> [type](#output\_type) | The DNS record type. |
<!-- END_TF_DOCS -->

## License

See [LICENSE](LICENSE).
