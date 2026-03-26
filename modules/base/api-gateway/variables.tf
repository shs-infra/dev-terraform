variable "name" {
    description = "Name of the API"
    type = string
    nullable = false
}

variable "stage_name" {
    description = "Stage name as $default"
    type = string
    nullable = false
    default = "$default"
}

variable "access_logs" {
  description = "Access log configuration"
  type = object({
    retention = optional(number)
    extra_fields    = optional(map(string), {})
  })
  
  default = {}
}

variable "custom_domain" {
  description = "Custom domain configuration for the API Gateway"
  type = object({
    domain_name     = string
    certificate_arn = string
  })

  default = null

  validation {
    condition = (
      var.custom_domain == null ||
      (
        length(var.custom_domain.domain_name) > 0 &&
        length(var.custom_domain.certificate_arn) > 0
      )
    )
    error_message = "If custom_domain is provided, both domain_name and certificate_arn must be non-empty."
  }
}

variable "tags" {
  description = "Common tags applied to resources"
  type = map(string)
  default = {}
}