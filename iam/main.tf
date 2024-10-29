data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

module "iam_role" {
  source  = "schubergphilis/mcaf-role/aws"
  version = "0.4.0"

  name          = "${var.name}-${var.region}"
  assume_policy = data.aws_iam_policy_document.assume_policy.json
  tags          = var.tags

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs",
  ]
}
