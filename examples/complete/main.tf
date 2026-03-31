// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "aws_region" "current" {}

data "aws_vpcs" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  cloud_resource_type     = each.value.name
  maximum_length          = each.value.max_length
  region                  = join("", split("-", data.aws_region.current.name))
}

resource "aws_route53_zone" "private" {
  name = "${module.resource_names["hosted_zone"].standard}.internal"

  vpc {
    vpc_id = one(data.aws_vpcs.default.ids)
  }

  tags = var.tags
}

locals {
  record_zone_id = coalesce(var.zone_id, aws_route53_zone.private.zone_id)
  record_name    = coalesce(var.name, module.resource_names["record"].standard)
}

module "route53_record" {
  source = "../.."

  zone_id = local.record_zone_id
  name    = local.record_name
  type    = var.type
  ttl     = var.ttl
  records = var.records
  alias   = var.alias

  set_identifier                   = var.set_identifier
  health_check_id                  = var.health_check_id
  allow_overwrite                  = var.allow_overwrite
  multivalue_answer_routing_policy = var.multivalue_answer_routing_policy
  weighted_routing_policy          = var.weighted_routing_policy
  failover_routing_policy          = var.failover_routing_policy
  geolocation_routing_policy       = var.geolocation_routing_policy
  latency_routing_policy           = var.latency_routing_policy
  cidr_routing_policy              = var.cidr_routing_policy
  timeouts                         = var.timeouts
}
