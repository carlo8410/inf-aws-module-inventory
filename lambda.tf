# Lambda Function
resource "aws_lambda_function" "register_product" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "register-product"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      ENV = "dev"
    }
  }
}
