# HTTP API Gateway with OpenAPI 3.0
resource "aws_apigatewayv2_api" "main" {
  name          = "mc-inventory-api"
  protocol_type = "HTTP"

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "mc-inventory-api"
      version = "1.0"
    }
    paths = {
      "/products" = {
        post = {
          x-amazon-apigateway-integration = {
            httpMethod           = "POST"
            payloadFormatVersion = "2.0"
            type                 = "aws_proxy"
            uri                  = aws_lambda_function.register_product.invoke_arn
          }
        }
      }
    }
  })
}

# Default Stage with Auto-Deploy
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = "$default"
  auto_deploy = true
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.register_product.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}

# Output the API URL
output "api_url" {
  description = "The base URL of the API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}
