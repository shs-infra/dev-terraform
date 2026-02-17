data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic_logs" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "xray" {
  count = var.enable_tracing ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  count = lower(var.package_type) == "image" ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = toset(var.additional_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.this.arn

  package_type = title(lower(var.package_type))

  handler = local.is_zip ? var.handler : null
  runtime = local.is_zip ? var.runtime : null

  filename         = local.is_zip ? var.filename : null
  source_code_hash = local.is_zip ? filebase64sha256(var.filename) : null

  image_uri = local.is_image ? var.image_uri : null

  memory_size = var.memory_size
  timeout     = var.timeout

  architectures = [var.architectures]

  environment {
    variables = merge(
      var.environment_variables,
      {
        LOG_LEVEL = var.log_level
      }
    )
  }

  tracing_config {
    mode = var.enable_tracing ? "Active" : "PassThrough"
  }

  logging_config {
    log_format = "JSON"
    application_log_level = var.log_level
    log_group  = aws_cloudwatch_log_group.this.name
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [image_uri]
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy_attachment.basic_logs,
    aws_iam_role_policy_attachment.xray,
    aws_iam_role_policy_attachment.ecr_access,
    aws_iam_role_policy_attachment.additional
  ]
}