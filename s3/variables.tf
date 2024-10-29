variable "name" {
  description = "The name of the bucket"
  type        = string
}

variable "region" {
  description = "The region to deploy the S3 to"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources"
  type        = map(string)
}
