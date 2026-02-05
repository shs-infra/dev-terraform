resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = upper(var.billing_mode)

  read_capacity  = upper(var.billing_mode) == "PROVISIONED" ? var.read_capacity : null
  write_capacity = upper(var.billing_mode) == "PROVISIONED" ? var.write_capacity : null

  hash_key = var.partition_key

  attribute {
    name = var.partition_key
    type = var.partition_key_type
  }

  range_key = var.sort_key.enabled ? var.sort_key.name : null

  dynamic "attribute" {
    for_each = var.sort_key.enabled ? [var.sort_key] : []

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = var.enable_pitr
  }

  ttl {
    enabled        = var.ttl.enabled
    attribute_name = var.ttl.enabled ? var.ttl.attribute_name : null
  }

  tags = var.tags
}