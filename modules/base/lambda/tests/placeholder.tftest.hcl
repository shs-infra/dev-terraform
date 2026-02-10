#Smoke test

mock_provider "aws" {}

run "smoke_test" {
    command = plan

    variables {
        function_name = ""
    }

    expect_failures = [
        var.function_name,
        var.package_type
    ]
}