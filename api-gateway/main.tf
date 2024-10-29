resource "aws_api_gateway_rest_api" "default" {
  name        = "${var.name}-${var.region}"
  description = "This is my API for demonstration purposes"
  tags        = var.tags

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "folder" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = "{folder}"
}

resource "aws_api_gateway_resource" "item" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_resource.folder.id
  path_part   = "{item}"
}

resource "aws_api_gateway_method" "default" {
  rest_api_id   = aws_api_gateway_rest_api.default.id
  resource_id   = aws_api_gateway_resource.item.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.folder" : true,
    "method.request.path.item" : true,
  }
}

resource "aws_api_gateway_method_response" "status_200" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.item.id
  http_method = aws_api_gateway_method.default.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "default" {
  rest_api_id             = aws_api_gateway_rest_api.default.id
  resource_id             = aws_api_gateway_resource.item.id
  http_method             = aws_api_gateway_method.default.http_method
  integration_http_method = aws_api_gateway_method.default.http_method
  type                    = "AWS"
  credentials             = var.iam_role_arn
  timeout_milliseconds    = 29000
  uri                     = "arn:aws:apigateway:${var.region}:s3:path/{bucket}/{object}"

  request_parameters = {
    "integration.request.path.bucket" = "method.request.path.folder",
    "integration.request.path.object" = "method.request.path.item",
  }
}

resource "aws_api_gateway_integration_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.default.id
  resource_id = aws_api_gateway_resource.item.id
  http_method = aws_api_gateway_method.default.http_method
  status_code = aws_api_gateway_method_response.status_200.status_code

  response_templates = {
    "application/json" = null
  }
}

resource "aws_api_gateway_deployment" "default" {
  rest_api_id = aws_api_gateway_rest_api.default.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.folder,
      aws_api_gateway_resource.item,
      aws_api_gateway_method.default,
      aws_api_gateway_integration.default,
      aws_api_gateway_rest_api.default.body
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.default.id
  rest_api_id   = aws_api_gateway_rest_api.default.id
  stage_name    = "v1"
  tags          = var.tags
}
