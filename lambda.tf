# Lambda Function
resource "aws_lambda_function" "register_product" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "mc-register-product-lambda"
  role             = aws_iam_role.mc-register-product-lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs24.x"
  publish          = true

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# Alias pointing to the latest code ($LATEST)
resource "aws_lambda_alias" "register_product_latest" {
  name             = "latest"
  description      = "Alias pointing to the latest code ($LATEST)"
  function_name    = aws_lambda_function.register_product.function_name
  function_version = "$LATEST"
}

# Alias pointing to a specific version (V1)
resource "aws_lambda_alias" "register_product_fixed" {
  name             = "fixed"
  description      = "Alias for stable version 1"
  function_name    = aws_lambda_function.register_product.function_name
  function_version = "1"

  lifecycle {
    ignore_changes = [
      function_version,
      routing_config
    ]
  }
}

