variable "identity_token" {
  type        = string
  description = "The identity token to use for the deployment"
  ephemeral   = true
}

variable "name" {
  type        = string
  description = "The name for the resources"
}

variable "regions" {
  type        = set(string)
  description = "The regions to deploy the resources to"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the role to assume for the deployment"
  ephemeral   = true
}

variable "tags" {
  description = "A map of tags to apply to all AWS resources"
  type        = map(string)
}
