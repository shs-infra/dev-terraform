locals {
  default_access_log_format = {
    requestId      = "$context.requestId"
    ip             = "$context.identity.sourceIp"
    requestTime    = "$context.requestTime"
    httpMethod     = "$context.httpMethod"
    routeKey       = "$context.routeKey"
    status         = "$context.status"
    protocol       = "$context.protocol"
    responseLength = "$context.responseLength"

    latency          = "$context.responseLatency"
    integrationError = "$context.integrationErrorMessage"
  }

  access_log_format = jsonencode(
    merge(
      local.default_access_log_format,
      try(var.access_logs.extra_fields, {})
    )
  )

  log_retention = coalesce(var.access_logs.retention, 30)
}