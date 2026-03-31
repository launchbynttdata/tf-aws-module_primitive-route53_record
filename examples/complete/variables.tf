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

variable "logical_product_family" {
  description = "Product family segment for resource naming."
  type        = string
}

variable "logical_product_service" {
  description = "Product service segment for resource naming."
  type        = string
}

variable "class_env" {
  description = "Environment class for resource naming."
  type        = string
}

variable "instance_env" {
  description = "Instance of the environment (0–999)."
  type        = number
}

variable "instance_resource" {
  description = "Instance of the resource (0–100)."
  type        = number
}

variable "resource_names_map" {
  description = "Map of resource naming keys to cloud_resource_type and max_length."
  type = map(object({
    name       = string
    max_length = number
  }))
}

variable "tags" {
  description = "Tags applied to the private hosted zone."
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  description = "Hosted zone ID for the record module. Leave null to use the private zone created in this example."
  type        = string
  default     = null
}

variable "name" {
  description = "DNS name for the record module. Leave null to use the resource naming output for key \"record\"."
  type        = string
  default     = null
}

variable "type" {
  description = "DNS record type for the example record."
  type        = string
}

variable "ttl" {
  description = "TTL in seconds for the record."
  type        = number
  default     = null
}

variable "records" {
  description = "Record values (e.g. IPv4 for type A)."
  type        = list(string)
  default     = null
}

variable "alias" {
  description = "Optional alias target block for the record module."
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })
  default = null
}

variable "set_identifier" {
  description = "Optional routing set identifier."
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "Optional health check ID."
  type        = string
  default     = null
}

variable "allow_overwrite" {
  description = "Allow overwriting an existing record with the same name and type."
  type        = bool
  default     = false
}

variable "multivalue_answer_routing_policy" {
  description = "Enable multivalue answer routing when set."
  type        = bool
  default     = null
}

variable "weighted_routing_policy" {
  description = "Optional weighted routing policy."
  type = object({
    weight = number
  })
  default = null
}

variable "failover_routing_policy" {
  description = "Optional failover routing policy."
  type = object({
    type = string
  })
  default = null
}

variable "geolocation_routing_policy" {
  description = "Optional geolocation routing policy."
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

variable "latency_routing_policy" {
  description = "Optional latency routing policy."
  type = object({
    region = string
  })
  default = null
}

variable "cidr_routing_policy" {
  description = "Optional CIDR (IP-based) routing policy."
  type = object({
    collection_id = string
    location_name = optional(string)
  })
  default = null
}

variable "timeouts" {
  description = "Optional Terraform timeouts for the record resource."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}
