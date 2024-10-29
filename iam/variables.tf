variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "region" {
  description = "The region to deploy the IAM role to"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources"
  type        = map(string)
}
