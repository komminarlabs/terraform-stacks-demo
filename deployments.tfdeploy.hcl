locals {
  name    = "terraform-stacks-demo"
  project = "Demo"
  stack   = "terraform-stacks-demo"
}

store "varset" "oidc_role_arn" {
  id       = "varset-vre8k5fyfNFogyDn"
  category = "terraform"
}

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    name           = "dev-${local.name}"
    identity_token = identity_token.aws.jwt
    regions        = ["eu-central-1"]
    role_arn       = store.varset.oidc_role_arn.dev

    tags = {
      Environment = "development"
      Stack       = local.stack
      Project     = local.project
    }
  }
}

deployment "production" {
  inputs = {
    name           = "prd-${local.name}"
    identity_token = identity_token.aws.jwt
    regions        = ["eu-central-1", "eu-west-1"]
    role_arn       = store.varset.oidc_role_arn.prd

    tags = {
      Environment = "production"
      Stack       = local.stack
      Project     = local.project
    }
  }
}

orchestrate "auto_approve" "non_prd" {
  check {
    condition = context.plan.deployment != deployment.production
    reason    = "Plan is production."
  }
}

orchestrate "auto_approve" "prd_no_modifications_or_destructions" {
  check {
    condition = context.plan.changes.change == 0
    reason    = "Plan is modifying ${context.plan.changes.change} resources."
  }

  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plan is destroying ${context.plan.changes.remove} resources."
  }

  check {
    condition = context.plan.deployment == deployment.production
    reason    = "Plan is not production."
  }
}

orchestrate "replan" "prod_for_errors" {
  check {
    condition = context.plan.deployment == deployment.production
    reason    = "Only automatically replan production deployments."
  }

  check {
    condition = context.plan.applyable == false
    reason    = "Only automatically replan plans that were not applyable."
  }

  check {
    condition = context.plan.replans < 2
    reason    = "Only automatically replan failed plans once."
  }
}
