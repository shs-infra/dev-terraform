locals {
  service_prefix = "parcel-${var.stage}"

  table_name = "${local.service_prefix}-packages"

  lambda_name = "${local.service_prefix}-api"

  log_level_by_stage = {
    dev = "DEBUG"
    stage = "INFO"
    prod = "WARN"
  }

  log_level = local.log_level_by_stage[var.stage]

  log_retention_by_stage = {
    dev = 3
    stage = 7
    prod = 30
  }

  log_retention = local.log_retention_by_stage[var.stage]

  image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.service_prefix}:initial"

  endpoints = [
    {
      method = "POST"
      path = "/parcel/status"
    }
  ]

  route_map = {
    for ep in local.endpoints :
    "${upper(ep.method)} ${ep.path}" => ep
  }

  service_tags = {
    Service = "parcel"
  }
}