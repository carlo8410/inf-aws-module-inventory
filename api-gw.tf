resource "aws_api_gateway_rest_api" "mc_inventory_api" {
  name        = "mc-inventory-api"
  description = "Base REST API Gateway for Module Inventory managed by Infrastructure"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_api_gateway_deployment" "mc_inventory_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.mc_inventory_api.id
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "mc_inventory_api_stage_dev" {
  deployment_id = aws_api_gateway_deployment.mc_inventory_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.mc_inventory_api.id
  stage_name    = "dev"
}

# Outputs for the Application Repository
output "api_gateway_id" {
  description = "The ID of the REST API Gateway to be used in the Lambda repo"
  value       = aws_api_gateway_rest_api.mc_inventory_api.id
}

output "api_gateway_execution_arn" {
  description = "The execution ARN of the REST API Gateway"
  value       = aws_api_gateway_rest_api.mc_inventory_api.execution_arn
}

output "api_url" {
  description = "The base URL of the REST API Gateway"
  value       = aws_api_gateway_stage.mc_inventory_api_stage_dev.invoke_url
}

