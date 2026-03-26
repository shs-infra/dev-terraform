output "api_id" {
  description = "ID of the API"
  value       = aws_apigatewayv2_api.this.id
}

output "execution_arn" {
  description = "Execution ARN of the API"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "invoke_url" {
  description = "Invoke URL of the API"
  value = (
    var.custom_domain != null
    ? "https://${var.custom_domain.domain_name}"
    : aws_apigatewayv2_api.this.api_endpoint
  )
}