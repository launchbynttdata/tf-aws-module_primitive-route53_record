# Changelog

## [Unreleased]

### Breaking Changes

- Upgraded AWS provider from `~> 5.100` to `~> 6.0`
- Updated Terraform version constraint from `~> 1.9` to `~> 1.10`

### Added

- `SSHFP` and `TLSA` record types to the `type` variable validation (newly supported in provider v6)

### Fixed

- Replaced deprecated `data.aws_region.current.name` with `.id` in example

### Validation

- Reviewed AWS provider v6 upgrade guide: no breaking changes to `aws_route53_record`
- Reviewed `aws_route53_record` resource documentation for provider v6
- Updated type validation to include newly supported record types
