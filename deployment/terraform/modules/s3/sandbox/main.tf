data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "machmain-erp-elb-access-logs-dev"
  force_destroy = true
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${data.aws_elb_service_account.main.arn}"]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::machmain-erp-elb-access-logs-dev/*"
    },
    {
      "Action": ["s3:PutObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::machmain-erp-elb-access-logs-dev/*",
	    "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Principal": {
	      "Service": "delivery.logs.amazonaws.com"
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::machmain-erp-elb-access-logs-dev"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.elb_logs.id
  acl    = "private"
}