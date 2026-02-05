mock_provider "aws" {}

# Prevents bypassing required inputs with empty values

run "table_name_must_not_be_empty" {
  command = plan

  variables {
    partition_key = "id"
    table_name = ""
  }

  expect_failures = [var.table_name]
}

run "partition_key_must_not_be_empty" {
  command = plan

  variables {
    partition_key = ""
    table_name = "table_name"
  }

  expect_failures = [var.partition_key]
}

# PAY_PER_REQUEST MUST NOT allow capacity
run "pay_per_request_with_capacity_is_invalid" {
  command = plan

  variables {
    table_name     = "test-table"
    partition_key = "id"

    billing_mode   = "PAY_PER_REQUEST"
    read_capacity  = 5
    write_capacity = 5
  }

  expect_failures = [
    var.billing_mode
  ]
}

# PROVISIONED MUST require read/write capacity
run "provisioned_without_capacity_is_invalid" {
  command = plan

  variables {
    table_name     = "test-table"
    partition_key = "id"
    billing_mode = "PROVISIONED"
  }

  expect_failures = [
    var.billing_mode
  ]
}

# Detects changes to validation or defaults that would permit 
# partial or implicit inputs configuration

#sort_key
run "sort_key_enabled_without_required_fields_fails" {
    command = plan

    variables {
        table_name = "test"
        partition_key = "id"

        sort_key = {
            enabled = true
            # name and type intentionally missing
        }
    }

    expect_failures = [var.sort_key]
}

#ttl_attribute
run "ttl_enabled_without_attribute_fails" {
    command = plan

    variables {
        table_name = "test"
        partition_key = "id"

        ttl = {
            enabled = true
            # attribute_name intentionally missing
        }
    }

    expect_failures = [var.ttl]
}