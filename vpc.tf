resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "vpc_task" {
  name_prefix = "vpc-tynar"
  vpc_id      = aws_vpc.vpc-tynar.id
}


resource "aws_cloudtrail" "example" {
  name                          = "cloud-trail-tynar"
  s3_bucket_name                = "example-bucket"
  include_global_service_events = true
  is_multi_region_trail         = true
}

resource "aws_flow_log" "example" {
  log_destination = aws_cloudtrail.example.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.example.id
  subnet_id       = aws_subnet.example.id
  iam_role_arn    = aws_cloudtrail.example.iam_role_arn
}