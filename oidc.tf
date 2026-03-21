# OIDC Identity Provider for GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# IAM Role for GitHub Actions to assume
resource "aws_iam_role" "github_actions_oidc" {
  name = "github-actions-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:carlo8410/inf-aws-module-inventory:*"
          }
        }
      }
    ]
  })
}

# Permissions for the role (AdministratorAccess for simplicity in this example)
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Role ARN Output
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_oidc.arn
  description = "Copy this ARN to your GitHub Action workflow"
}
