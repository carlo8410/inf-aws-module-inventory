# Zip a placeholder bootstrap code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content  = "exports.handler = async (event) => { console.warn('BOOTSTRAP: Please deploy real code'); return { statusCode: 200, body: JSON.stringify('Bootstrap response') }; };"
    filename = "index.js"
  }
}

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
