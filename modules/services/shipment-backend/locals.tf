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

  image_uri = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.region}.amazonaws.com/${local.service_prefix}:initial"

  service_tags = {
    Service = "parcel"
  }
}