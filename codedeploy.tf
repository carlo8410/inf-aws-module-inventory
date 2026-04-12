# CodeDeploy Application
resource "aws_codedeploy_app" "mc_inventory" {
  compute_platform = "Lambda"
  name             = "mc-inventory-app"
}

# CodeDeploy Deployment Group for Register Product
resource "aws_codedeploy_deployment_group" "register_product" {
  app_name               = aws_codedeploy_app.mc_inventory.name
  deployment_group_name  = "mc-register-product-dg"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = "CodeDeployDefault.LambdaCanary10Percent5Minutes"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
