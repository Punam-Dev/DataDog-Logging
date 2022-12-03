variable "region" {}
variable "account" {}
variable "environment" { default = "sandbox"}
variable "vpc_id" { default = "vpc-14925a7f" }
variable "app_name" { default = "datadog-logging" }
variable "name_initials" { default = "mchmn" }
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" { default = ["subnet-c2cbec8e", "subnet-af1178d4", "subnet-53649238"] }
variable "guid" { default = "e218e0e7-89d7-4efa-9695-30d347800b1f" }
variable "asset_id" { default = "214" }
variable "asset_name" { default = "Datadog Logging" }
variable "asset_group" { default = "Dev" }
variable "asset_purpose" { default = "Test" }
variable "alb_subnets" { default = ["subnet-c2cbec8e", "subnet-af1178d4", "subnet-53649238"] }
variable "domain_name" { default = "punamaws.click" }
variable "dns_name" { default = "datadoglogging.punamaws.click" }
variable "internal" { default = false }
variable "inbound_cidr" {
  type = list(string)
  default = ["0.0.0.0/0"]
}
variable "bucket_name" {default = "datadoglogging-elb-access-logs-dev" }
variable "ebs_root_volume_size" { default = "30" }
variable "session_name" {}
variable "aspnetcore_environment" { default = "Development"}