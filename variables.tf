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

variable "zone_id" {
  description = "The ID of the hosted zone that contains this resource record set."
  type        = string
}

variable "name" {
  description = "DNS domain name for the record (relative to the zone or fully qualified)."
  type        = string
}

variable "type" {
  description = "DNS record type."
  type        = string

  validation {
    condition = contains([
      "SOA", "A", "TXT", "NS", "CNAME", "MX", "NAPTR", "PTR", "SRV", "SPF", "AAAA", "CAA", "DS",
      "HTTPS", "SVCB"
    ], var.type)
    error_message = "Type must be a supported Route 53 DNS record type."
  }
}

variable "ttl" {
  description = "TTL of the record in seconds. Omit when using an alias record."
  type        = number
  default     = null

  validation {
    condition     = var.ttl == null ? true : (var.ttl >= 0 && var.ttl <= 2147483647)
    error_message = "TTL must be between 0 and 2147483647 seconds."
  }
}

variable "records" {
  description = "String records for non-alias records (e.g. IPv4 for A, text for TXT)."
  type        = list(string)
  default     = null
}

variable "alias" {
  description = <<-EOT
    Alias target (e.g. ELB, CloudFront). When set, do not set ttl or records.
    The inner `name` is the DNS name to point to (e.g. load balancer DNS name).
  EOT
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })
  default = null
}

variable "set_identifier" {
  description = "Unique identifier for weighted, latency, geolocation, or failover routing."
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "Health check ID to associate with alias, weighted, or failover routing."
  type        = string
  default     = null
}

variable "allow_overwrite" {
  description = "Allow overwriting an existing record set with the same name and type."
  type        = bool
  default     = false
}

variable "multivalue_answer_routing_policy" {
  description = "Set to true for multivalue answer routing."
  type        = bool
  default     = null
}

variable "weighted_routing_policy" {
  description = "Weighted routing policy block."
  type = object({
    weight = number
  })
  default = null

  validation {
    condition     = var.weighted_routing_policy == null ? true : (var.weighted_routing_policy.weight >= 0 && var.weighted_routing_policy.weight <= 255)
    error_message = "Weighted routing weight must be between 0 and 255."
  }
}

variable "failover_routing_policy" {
  description = "Failover routing policy block."
  type = object({
    type = string
  })
  default = null

  validation {
    condition     = var.failover_routing_policy == null ? true : contains(["PRIMARY", "SECONDARY"], var.failover_routing_policy.type)
    error_message = "Failover type must be PRIMARY or SECONDARY."
  }
}

variable "geolocation_routing_policy" {
  description = "Geolocation routing policy block."
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null

  validation {
    condition = var.geolocation_routing_policy == null ? true : (
      (try(var.geolocation_routing_policy.continent, null) != null && try(var.geolocation_routing_policy.continent, "") != "") ||
      (try(var.geolocation_routing_policy.country, null) != null && try(var.geolocation_routing_policy.country, "") != "") ||
      (try(var.geolocation_routing_policy.subdivision, null) != null && try(var.geolocation_routing_policy.subdivision, "") != "")
    )
    error_message = "When geolocation_routing_policy is set, at least one of continent, country, or subdivision must be non-empty."
  }
}

variable "cidr_routing_policy" {
  description = "CIDR (IP-based) routing policy block."
  type = object({
    collection_id = string
    location_name = optional(string)
  })
  default = null
}

variable "latency_routing_policy" {
  description = "Latency routing policy block."
  type = object({
    region = string
  })
  default = null
}

variable "timeouts" {
  description = "Create, update, and delete timeouts for the record set change."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}
