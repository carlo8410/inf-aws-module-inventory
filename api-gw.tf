resource "aws_api_gateway_rest_api" "mc_inventory_api" {
  name        = "mc-inventory-api"
  description = "Base REST API Gateway for Module Inventory managed by Infrastructure"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
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

