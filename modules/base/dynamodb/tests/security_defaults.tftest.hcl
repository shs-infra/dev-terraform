mock_provider "aws" {}

# Verifies that default configuration is safe when only required inputs are provided. 
# Detects changes to the default configuration that could silently affect cost, data model, or data lifecycle policy.

run "creates_table_with_default_configuration" {
    command = plan

    variables {
        table_name = "table_name"
        partition_key = "id"
    }
    
# Sort key
    assert {
        condition     = aws_dynamodb_table.this.range_key == null
        error_message = "Sort key must not be set by default"
    }

    # Only partition key attribute exists by default
    assert {
        condition     = length(aws_dynamodb_table.this.attribute) == 1
        error_message = "Only partition key attribute must exist by default"
    }

    # billing_mode
    assert {
        condition     = aws_dynamodb_table.this.billing_mode == "PAY_PER_REQUEST"
        error_message = "Default billing_mode must be PAY_PER_REQUEST"
    }

    # read_capacity/write_capacity must not exist
    assert {
        condition     = var.read_capacity == null
        error_message = "read_capacity must be null for PAY_PER_REQUEST"
    }

    assert {
        condition     = var.write_capacity == null
        error_message = "write_capacity must be null for PAY_PER_REQUEST"
    }

    # PITR enabled by default
    assert {
        condition     = aws_dynamodb_table.this.point_in_time_recovery[0].enabled == true
        error_message = "PITR must be enabled by default"
    }

    # TTL disabled by default
    assert {
        condition = aws_dynamodb_table.this.ttl[0].enabled == false
        error_message = "TTL block must not exist by default"
    }
}