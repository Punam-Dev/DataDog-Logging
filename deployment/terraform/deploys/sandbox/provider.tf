terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn = "arn:aws:iam::579253604158:role/terraform-user-deployment-role"
    session_name = var.session_name
  }
  default_tags {
    tags = {
      Name = var.app_name
      GUID = var.guid
      AssetID = var.asset_id
      AssetName = var.asset_name
      AssetGroup = var.asset_group
      AssetPurpose = var.asset_purpose
    }
  }
}