# Primary REST API Gateway (Skeleton)
# The routes and integrations are managed in the Application (Lambda) repository via OpenAPI.
resource "aws_api_gateway_rest_api" "main" {
  name        = "mc-inventory-api"
  description = "Base REST API Gateway for Module Inventory managed by Infrastructure"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Deployment (Required for REST API context)
# Note: Real deployments will likely be triggered from the Lambda repo when the body is updated.
resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }
}

# Production Stage
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "prod"
}

# Outputs for the Application Repository
output "api_gateway_id" {
  description = "The ID of the REST API Gateway to be used in the Lambda repo"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_gateway_execution_arn" {
  description = "The execution ARN of the REST API Gateway"
  value       = aws_api_gateway_rest_api.main.execution_arn
}

output "api_url" {
  description = "The base URL of the REST API Gateway"
  value       = "${aws_api_gateway_deployment.main.invoke_url}prod"
}
