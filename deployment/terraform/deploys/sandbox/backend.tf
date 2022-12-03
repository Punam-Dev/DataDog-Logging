terraform {
  backend "s3" {
    bucket = "datadog-logging-sandbox"
    key = "datadog-logging-sandbox.tfstate"
    region = "ap-south-1"
    role_arn = "arn:aws:iam::579253604158:role/terraform-user-deployment-role"
    encrypt = true
  }
}