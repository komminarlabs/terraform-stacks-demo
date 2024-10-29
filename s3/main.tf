module "s3_bucket" {
  source  = "schubergphilis/mcaf-s3/aws"
  version = "0.14.1"

  name          = "${var.name}-${var.region}"
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_object" "demo" {
  bucket  = module.s3_bucket.id
  key     = "demo.txt"
  content = "Demo API Gateway to S3 integration using Terraform Stacks"
}
