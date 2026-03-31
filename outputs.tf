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

output "id" {
  description = "The Route 53 record set ID (hosted zone ID, record name, and type)."
  value       = aws_route53_record.record.id
}

output "name" {
  description = "The name of the record."
  value       = aws_route53_record.record.name
}

output "fqdn" {
  description = "The FQDN built from the record name and zone (trailing dot omitted)."
  value       = aws_route53_record.record.fqdn
}

output "type" {
  description = "The DNS record type."
  value       = aws_route53_record.record.type
}
