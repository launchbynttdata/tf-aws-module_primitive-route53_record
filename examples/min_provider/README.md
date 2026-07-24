# min_provider

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_route53_record"></a> [route53\_record](#module\_route53\_record) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpcs.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | Optional alias target block for the record module. | <pre>object({<br/>    name                   = string<br/>    zone_id                = string<br/>    evaluate_target_health = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_allow_overwrite"></a> [allow\_overwrite](#input\_allow\_overwrite) | Allow overwriting an existing record with the same name and type. | `bool` | `false` | no |
| <a name="input_cidr_routing_policy"></a> [cidr\_routing\_policy](#input\_cidr\_routing\_policy) | Optional CIDR (IP-based) routing policy. | <pre>object({<br/>    collection_id = string<br/>    location_name = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment class for resource naming. | `string` | n/a | yes |
| <a name="input_failover_routing_policy"></a> [failover\_routing\_policy](#input\_failover\_routing\_policy) | Optional failover routing policy. | <pre>object({<br/>    type = string<br/>  })</pre> | `null` | no |
| <a name="input_geolocation_routing_policy"></a> [geolocation\_routing\_policy](#input\_geolocation\_routing\_policy) | Optional geolocation routing policy. | <pre>object({<br/>    continent   = optional(string)<br/>    country     = optional(string)<br/>    subdivision = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_geoproximity_routing_policy"></a> [geoproximity\_routing\_policy](#input\_geoproximity\_routing\_policy) | Optional geoproximity routing policy. | <pre>object({<br/>    aws_region       = optional(string)<br/>    bias             = optional(number)<br/>    local_zone_group = optional(string)<br/>    coordinates = optional(list(object({<br/>      latitude  = string<br/>      longitude = string<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_health_check_id"></a> [health\_check\_id](#input\_health\_check\_id) | Optional health check ID. | `string` | `null` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Instance of the environment (0–999). | `number` | n/a | yes |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Instance of the resource (0–100). | `number` | n/a | yes |
| <a name="input_latency_routing_policy"></a> [latency\_routing\_policy](#input\_latency\_routing\_policy) | Optional latency routing policy. | <pre>object({<br/>    region = string<br/>  })</pre> | `null` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Product family segment for resource naming. | `string` | n/a | yes |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Product service segment for resource naming. | `string` | n/a | yes |
| <a name="input_multivalue_answer_routing_policy"></a> [multivalue\_answer\_routing\_policy](#input\_multivalue\_answer\_routing\_policy) | Enable multivalue answer routing when set. | `bool` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | DNS name for the record module. Leave null to use the resource naming output for key "record". | `string` | `null` | no |
| <a name="input_records"></a> [records](#input\_records) | Record values (e.g. IPv4 for type A). | `list(string)` | `null` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | Map of resource naming keys to cloud\_resource\_type and max\_length. | <pre>map(object({<br/>    name       = string<br/>    max_length = number<br/>  }))</pre> | n/a | yes |
| <a name="input_set_identifier"></a> [set\_identifier](#input\_set\_identifier) | Optional routing set identifier. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the private hosted zone. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Optional Terraform timeouts for the record resource. | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_ttl"></a> [ttl](#input\_ttl) | TTL in seconds for the record. | `number` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | DNS record type for the example record. | `string` | n/a | yes |
| <a name="input_weighted_routing_policy"></a> [weighted\_routing\_policy](#input\_weighted\_routing\_policy) | Optional weighted routing policy. | <pre>object({<br/>    weight = number<br/>  })</pre> | `null` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | Hosted zone ID for the record module. Leave null to use the private zone created in this example. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_expected_records"></a> [expected\_records](#output\_expected\_records) | Expected record values from configuration. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | FQDN of the record. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Hosted zone ID passed to the record module (created zone when zone\_id is null). |
| <a name="output_id"></a> [id](#output\_id) | Route 53 record set ID from the module. |
| <a name="output_record_name"></a> [record\_name](#output\_record\_name) | Record name returned by the module. |
| <a name="output_record_ttl"></a> [record\_ttl](#output\_record\_ttl) | Configured TTL for the record. |
| <a name="output_record_ttl_actual"></a> [record\_ttl\_actual](#output\_record\_ttl\_actual) | Actual TTL from the deployed record (null for alias records). |
| <a name="output_record_type"></a> [record\_type](#output\_record\_type) | DNS type of the record. |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | DNS name of the private hosted zone. |
<!-- END_TF_DOCS -->
