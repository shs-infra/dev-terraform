module "db" {
    source = "../../base/dynamodb"

    table_name = local.table_name

    partition_key = "parcel_id"

    enable_pitr = false

    tags = local.service_tags
}

module "lambda" {
    source = "../../base/lambda"

    function_name = local.lambda_name

    package_type = "image"

    image_uri = local.image_uri

    memory_size = 512
    timeout = 10

    environment_variables = {
        STAGE = var.stage
        TABLE_NAME = local.table_name
    }

    log_retention_days = 7

    log_level = local.log_level

    enable_tracing = true

    tags = local.service_tags
}

data "aws_iam_policy_document" "dynamodb_access" {
    statement {
        effect = "Allow"

        actions = [
            "dynamodb:GetItem"
        ]

        resources = [
            module.db.table_arn
        ]
    }
}

resource "aws_iam_role_policy" "dynamodb_access_policy" {
    name = "${local.service_prefix}-dynamodb"
    role = module.lambda.role_name

    policy = data.aws_iam_policy_document.dynamodb_access.json

    depends_on = [
        module.lambda,
        module.db
    ]
}

module "api" {
  source = "../../base/api-gateway"

  name = "${local.service_prefix}-api"

  access_logs = {
    retention = local.log_retention
  }

  custom_domain = var.custom_domain

  tags = local.service_tags
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id = module.api.api_id

  integration_type = "AWS_PROXY"

  integration_uri = module.lambda.invoke_arn

  payload_format_version = "2.0"

  timeout_milliseconds = 10000
}

resource "aws_apigatewayv2_route" "this" {
  for_each = local.route_map

  api_id = module.api.api_id

  route_key = each.key

  target = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "${local.service_prefix}-AllowExecutionFromAPIGateway"

  action = "lambda:InvokeFunction"

  function_name = module.lambda.function_arn

  principal = "apigateway.amazonaws.com"

  source_arn = "${module.api.execution_arn}/*/*"
}
