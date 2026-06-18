# CloudWatch Alarm for Lambda Errors
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "mc-register-product-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Alarm triggered when mc-register-product-lambda experiences errors."

  dimensions = {
    FunctionName = aws_lambda_function.register_product.function_name
  }
}

# CloudWatch Dashboard for MC Inventory API & Lambda
resource "aws_cloudwatch_dashboard" "inventory_dashboard" {
  dashboard_name = "mc-inventory-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.register_product.function_name, { "stat": "Sum" } ],
            [ ".", "Errors", ".", ".", { "stat": "Sum" } ]
          ]
          period  = 60
          region  = "us-east-2"
          title   = "Lambda Invocations & Errors"
          view    = "timeSeries"
          stacked = false
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [ "AWS/ApiGateway", "Count", "ApiName", aws_api_gateway_rest_api.mc_inventory_api.name, { "stat": "Sum" } ],
            [ ".", "5XXError", ".", ".", { "stat": "Sum" } ],
            [ ".", "4XXError", ".", ".", { "stat": "Sum" } ]
          ]
          period  = 60
          region  = "us-east-2"
          title   = "API Gateway Traffic and Errors"
          view    = "timeSeries"
          stacked = false
        }
      }
    ]
  })
}
