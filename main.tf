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

resource "aws_route53_record" "record" {
  zone_id                          = var.zone_id
  name                             = var.name
  type                             = var.type
  ttl                              = var.alias == null ? var.ttl : null
  records                          = var.alias == null ? var.records : null
  set_identifier                   = var.set_identifier
  health_check_id                  = var.health_check_id
  allow_overwrite                  = var.allow_overwrite
  multivalue_answer_routing_policy = var.multivalue_answer_routing_policy

  dynamic "alias" {
    for_each = var.alias != null ? [var.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  dynamic "weighted_routing_policy" {
    for_each = var.weighted_routing_policy != null ? [var.weighted_routing_policy] : []
    content {
      weight = weighted_routing_policy.value.weight
    }
  }

  dynamic "failover_routing_policy" {
    for_each = var.failover_routing_policy != null ? [var.failover_routing_policy] : []
    content {
      type = failover_routing_policy.value.type
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each = var.geolocation_routing_policy != null ? [var.geolocation_routing_policy] : []
    content {
      continent   = geolocation_routing_policy.value.continent
      country     = geolocation_routing_policy.value.country
      subdivision = geolocation_routing_policy.value.subdivision
    }
  }

  dynamic "latency_routing_policy" {
    for_each = var.latency_routing_policy != null ? [var.latency_routing_policy] : []
    content {
      region = latency_routing_policy.value.region
    }
  }

  dynamic "cidr_routing_policy" {
    for_each = var.cidr_routing_policy != null ? [var.cidr_routing_policy] : []
    content {
      collection_id = cidr_routing_policy.value.collection_id
      location_name = try(cidr_routing_policy.value.location_name, null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  lifecycle {
    precondition {
      condition     = var.alias == null ? true : (var.ttl == null && var.records == null)
      error_message = "When alias is set, ttl and records must be null."
    }
  }
}
