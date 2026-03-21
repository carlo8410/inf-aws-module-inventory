resource "aws_s3_bucket" "inf-aws-module-inventory" {
  bucket = "inf-aws-module-inventory-state"
  tags = {
    Name        = "save terraform state"
    Environment = "Dev"
  }
}