variable "stage" {
    description = "Environment stage"
    type = string
    nullable = false

    validation {
      condition = contains(["dev", "stage", "prod"], var.stage)
      error_message = "stage must be one of: dev, stage, prod"
    }
}