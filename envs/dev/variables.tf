variable "stage" {
    description = "Environment stage"
    type = string
    nullable = false
}

variable "custom_domain" {
  description = "Custom domain config for API Gateway"
  type = object({
    domain_name = string
    certificate_arn = string
  })
  default = null
}

variable "project_name" {
  type = string
  nullable = false
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
  default     = {}
}