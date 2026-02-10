output "function_arn" {
  description = "Lambda ARN"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Lambda invoke ARN"
  value       = aws_lambda_function.this.invoke_arn
}

output "role_name" {
  description = "IAM role name used by Lambda"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM role ARN used by Lambda"
  value       = aws_iam_role.this.arn
}