resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = "HTTP"

  # execute-api is disabled only if custom domain is enabled
  disable_execute_api_endpoint = var.custom_domain != null

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "access" {
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = local.log_retention

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "this" {
    api_id = aws_apigatewayv2_api.this.id 
    name = var.stage_name

    auto_deploy = true

    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.access.arn
        format = local.access_log_format
    }

    tags = var.tags
}

resource "aws_apigatewayv2_domain_name" "this" {
    count = var.custom_domain != null ? 1 : 0

    domain_name = var.custom_domain.domain_name

    domain_name_configuration {
        certificate_arn = var.custom_domain.certificate_arn
        endpoint_type = "REGIONAL"
        security_policy = "TLS_1_2"
    }

    tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
    count = var.custom_domain != null ? 1 : 0

    api_id = aws_apigatewayv2_api.this.id
    domain_name = aws_apigatewayv2_domain_name.this[0].id
    stage = aws_apigatewayv2_stage.this.name
}