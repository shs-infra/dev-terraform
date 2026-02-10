variable "package_type" {
  description = "Lambda package type: Zip or Image"
  type        = string
  default     = "zip"
  nullable    = false

  validation {
    condition     = contains(["zip", "image"], lower(var.package_type))
    error_message = "package_type must be zip or image"
  }

  validation {
    condition = (
      (
        lower(var.package_type) == "zip" &&
        var.filename != null &&
        var.handler != null &&
        var.runtime != null &&
        var.image_uri == null
      ) ||
      (
        lower(var.package_type) == "image" &&
        var.filename == null &&
        var.handler == null &&
        var.runtime == null &&
        var.image_uri != null
      )
    )

    error_message = "Invalid package_type configuration: for zip set filename, for image set image_uri"
  }
}

variable "additional_policy_arns" {
  type     = list(string)
  default  = []
  nullable = false
}

variable "filename" {
  description = "Path to Lambda ZIP file"
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI"
  type        = string
  default     = null
}

variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
  nullable    = false

  validation {
    condition = (
      length(var.function_name) <= 64 &&
      can(regex("^[a-zA-Z0-9-_]+$", var.function_name))
    )
    error_message = "Lambda name must be <= 64 chars and contain only allowed characters"
  }
}

variable "handler" {
  type        = string
  description = "Lambda handler to execute"
  default     = null
}

variable "runtime" {
  type        = string
  description = "Runtime for the Lambda function"
  default     = null

}

variable "memory_size" {
  description = "Memory size"
  type        = number
  default     = 128
  nullable    = false
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 3
  nullable    = false
}

variable "environment_variables" {
  description = "Optional environment variables"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 7
  nullable    = false
}

variable "enable_tracing" {
  description = "Enable X-Ray tracing"
  type        = bool
  default     = false
  nullable    = false
}

variable "architectures" {
  description = "Lambda architecture"
  type        = string
  default     = "x86_64"
  nullable    = false

  validation {
    condition     = contains(["x86_64", "arm64"], var.architectures)
    error_message = "Architecture must be either x86_64 or arm64"
  }
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to Lambda resources"
  default     = {}
}