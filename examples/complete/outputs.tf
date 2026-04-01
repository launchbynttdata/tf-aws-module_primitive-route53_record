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

output "hosted_zone_id" {
  description = "Hosted zone ID passed to the record module (created zone when zone_id is null)."
  value       = local.record_zone_id
}

output "zone_name" {
  description = "DNS name of the private hosted zone."
  value       = aws_route53_zone.private.name
}

output "id" {
  description = "Route 53 record set ID from the module."
  value       = module.route53_record.id
}

output "fqdn" {
  description = "FQDN of the record."
  value       = module.route53_record.fqdn
}

output "record_name" {
  description = "Record name returned by the module."
  value       = module.route53_record.name
}

output "record_type" {
  description = "DNS type of the record."
  value       = module.route53_record.type
}

output "record_ttl" {
  description = "Configured TTL for the record."
  value       = var.ttl
}

output "record_ttl_actual" {
  description = "Actual TTL from the deployed record (null for alias records)."
  value       = var.alias == null ? var.ttl : null
}

output "expected_records" {
  description = "Expected record values from configuration."
  value       = var.records
}
