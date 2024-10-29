component "s3" {
  for_each = var.regions
  source   = "./s3"

  providers = {
    aws = provider.aws.configurations[each.value]
  }

  inputs = {
    name   = var.name
    region = each.key
    tags   = var.tags
  }
}

component "iam" {
  for_each = var.regions
  source   = "./iam"

  providers = {
    aws = provider.aws.configurations[each.value]
  }

  inputs = {
    name   = var.name
    region = each.key
    tags   = var.tags
  }
}

component "api-gateway" {
  for_each = var.regions
  source   = "./api-gateway"

  providers = {
    aws = provider.aws.configurations[each.value]
  }

  inputs = {
    name         = var.name
    iam_role_arn = component.iam[each.value].arn
    region       = each.key
    tags         = var.tags
  }
}
