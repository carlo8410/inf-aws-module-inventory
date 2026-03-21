# Primary HTTP API Gateway (Skeleton)
# The routes and integrations are managed in the Application (Lambda) repository via OpenAPI.
resource "aws_apigatewayv2_api" "main" {
  name          = "mc-inventory-api"
  protocol_type = "HTTP"
  description   = "Base API Gateway for Module Inventory managed by Infrastructure"
}

# Default Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

# Outputs for the Application Repository
output "api_gateway_id" {
  description = "The ID of the API Gateway to be used in the Lambda repo"
  value       = aws_apigatewayv2_api.main.id
}

output "api_gateway_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.main.execution_arn
}

output "api_url" {
  description = "The base URL of the API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}
