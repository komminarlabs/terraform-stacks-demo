variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role to use for the API Gateway"
  type        = string
}

variable "region" {
  description = "The region to deploy the API Gateway to"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources"
  type        = map(string)
}
