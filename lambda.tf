# Lambda Function
resource "aws_lambda_function" "register_product" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "mc-register-product-lambda"
  role             = aws_iam_role.mc-register-product-lambda.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs24.x"
  environment {
    variables = {
      ENV = "dev"
    }
  }
}
