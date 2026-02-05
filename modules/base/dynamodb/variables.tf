variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  nullable    = false

  validation {
    condition     = length(trimspace(var.table_name)) > 0
    error_message = "table_name must not be empty"
  }
}

variable "partition_key" {
  description = "Partition key name"
  type        = string
  nullable    = false


  validation {
    condition     = length(trimspace(var.partition_key)) > 0
    error_message = "partition_key must not be empty"
  }
}

variable "partition_key_type" {
  description = "Partition key type"
  type        = string
  default     = "S"
  nullable    = false

  validation {
    condition     = contains(["S", "N", "B"], var.partition_key_type)
    error_message = "partition_key_type must be one of S, N, B"
  }
}

variable "sort_key" {
  type = object({
    enabled = bool
    name    = optional(string)
    type    = optional(string)
  })

  default = {
    enabled = false
  }

  validation {
    condition = (
      var.sort_key.enabled == false ||
      (
        var.sort_key.name != null &&
        length(trimspace(var.sort_key.name)) > 0 &&
        contains(["S", "N", "B"], var.sort_key.type)
      )
    )
    error_message = "When sort_key is enabled, name must be a non-empty string and type must be one of: S, N, B."
  }
}

variable "billing_mode" {
  description = "Billing mode"
  type        = string
  nullable    = false
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], upper(var.billing_mode))
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED"
  }

  validation {
    condition = (
      (
        upper(var.billing_mode) == "PAY_PER_REQUEST" &&
        var.read_capacity == null &&
        var.write_capacity == null
      )
      ||
      (
        upper(var.billing_mode) == "PROVISIONED" &&
        var.read_capacity != null &&
        var.write_capacity != null
      )
    )
    error_message = "For PROVISIONED read and write_capacity must be set; for PAY_PER_REQUEST read and write_capacity must be null"
  }
}

variable "read_capacity" {
  description = "Read capacity for PROVISIONED billing_mode"
  type        = number
  default     = null

  validation {
    condition = (
      var.read_capacity == null || var.read_capacity >= 1
    )
    error_message = "read_capacity must be >= 1"
  }
}

variable "write_capacity" {
  description = "Write capacity for PROVISIONED billing_mode"
  type        = number
  default     = null

  validation {
    condition = (
      var.write_capacity == null || var.write_capacity >= 1
    )
    error_message = "write_capacity must be >= 1"
  }
}

variable "enable_pitr" {
  description = "Point-in-time recovery"
  type        = bool
  default     = true
}

variable "ttl" {
  type = object({
    enabled        = bool
    attribute_name = optional(string)
  })

  default = {
    enabled = false
  }

  validation {
    condition = (
      var.ttl.enabled == false ||
      var.ttl.attribute_name != null &&
      length(trimspace(var.ttl.attribute_name)) > 0 &&
      can(regex("^[a-zA-Z0-9_]+$", var.ttl.attribute_name))
    )
    error_message = "When TTL is enabled, attribute_name must be a valid non-empty DynamoDB attribute name."
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}