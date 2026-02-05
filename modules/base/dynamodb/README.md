## Description

This module creates a DynamoDB table. It is intended to be used as a reusable base module accross services. 

## Quick start

```hcl
module "table" {
  source = "./modules/dynamodb"

  table_name    = "orders"
  partition_key = "order_id"
}
```

## Features

- Creates a DynamoDB table
- Supports `sort_key` configuration
- Supports `PAY_PER_REQUEST` and `PROVISIONED` billing modes
- Supports `ttl` configuration
- Supports `point-in-time` recovery
- Applies `tags` to all created resources

## Defaults

- `sort_key` is disabled by default and must be explicitly enabled by the user when required by a specific service's data model
- Billing mode: `PAY_PER_REQUEST` by default to avoid capacity planning and accidental throttling. Can be configured to `PROVISIONED` when predictable workloads are required.
- `TTL`: Optional and disabled by default to prevent unintended data deletion.
- `Point-in-time recovery`: Enabled by default to allow data recovery. Can be explicitly disabled when durability is not required.
- `tags` are empty map by default and can be easily merged with global tags

## Validation

  The module performs strict input validation at `terraform plan` time.

  The following configurations are rejected:
  - invalid `billing_mode` values
  - setting `read_capacity` or `write_capacity` when using `PAY_PER_REQUEST`
  - missing `read_capacity` or `write_capacity` when using `PROVISIONED`
  - invalid DynamoDB attribute types for keys
  - missing `sort_key.name` or `sort_key.type` when `sort_key` is enabled
  - missing or invalid `ttl.attribute_name` when `ttl` is enabled
  
## Non-goals

  This module does not:
  - manage GSIs or LSIs
  - provide autoscaling or capacity tuning recommendations
  - model DynamoDB access patterns or data schemas

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Billing mode | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_enable_pitr"></a> [enable\_pitr](#input\_enable\_pitr) | Point-in-time recovery | `bool` | `true` | no |
| <a name="input_partition_key"></a> [partition\_key](#input\_partition\_key) | Partition key name | `string` | n/a | yes |
| <a name="input_partition_key_type"></a> [partition\_key\_type](#input\_partition\_key\_type) | Partition key type | `string` | `"S"` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Read capacity for PROVISIONED billing\_mode | `number` | `null` | no |
| <a name="input_sort_key"></a> [sort\_key](#input\_sort\_key) | Sort key name | `string` | `null` | no |
| <a name="input_sort_key_type"></a> [sort\_key\_type](#input\_sort\_key\_type) | Sort key type. Ignored if sort\_key is null. | `string` | `"S"` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | DynamoDB table name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource tags | `map(string)` | `{}` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | TTL attribute name | `string` | `null` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Write capacity for PROVISIONED billing\_mode | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | DynamoDB table ARN |
<!-- END_TF_DOCS -->