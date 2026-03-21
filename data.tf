# Zip a placeholder bootstrap code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function_payload.zip"

  source {
    content  = "exports.handler = async (event) => { console.warn('BOOTSTRAP: Please deploy real code'); return { statusCode: 200, body: JSON.stringify('Bootstrap response') }; };"
    filename = "index.js"
  }
}
