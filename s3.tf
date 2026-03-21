resource "aws_s3_bucket" "cg_terraform_curso" {
  bucket = "cg-terraform-curso"
  tags = {
    Name        = "save terraform state"
    Environment = "Dev"
  }
}