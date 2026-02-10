## Description

This module creates a Lambda function and is intended to be used as a reusable base module across services.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policy_arns"></a> [additional\_policy\_arns](#input\_additional\_policy\_arns) | n/a | `list(string)` | `[]` | no |
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Lambda architecture | `string` | `"x86_64"` | no |
| <a name="input_enable_tracing"></a> [enable\_tracing](#input\_enable\_tracing) | Enable X-Ray tracing | `bool` | `false` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Optional environment variables | `map(string)` | `{}` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to Lambda ZIP file | `string` | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Lambda function | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | Lambda handler to execute | `string` | `null` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI | `string` | `null` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention | `number` | `7` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda package type: Zip or Image | `string` | `"zip"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Runtime for the Lambda function | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags applied to Lambda resources | `map(string)` | `{}` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout in seconds | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | Lambda ARN |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | Lambda invoke ARN |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | IAM role ARN used by Lambda |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | IAM role name used by Lambda |