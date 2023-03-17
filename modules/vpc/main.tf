resource "aws_vpc" "main" {
  cidr_block = "${var.cidr_block}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

}

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  # subnet_id     = "${aws_subnet.public_subnets.*.id}"
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)
  depends_on    = [aws_internet_gateway.gw]
}

#Public Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
}

#Private Subnets 
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.private_subnets)
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
}

#ROUTE TABLE
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

#Route Table association
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#Security Group 
# resource "aws_security_group" "vpc_task" {
#   name        = "vpc_task"
#   description = "Allow TLS inbound traffic"

#   ingress {
#     description = "Allow ssh"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }

resource "aws_flow_log" "vpc" {
  iam_role_arn    = aws_iam_role.flow_logs.arn
  traffic_type    = "ALL"
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  vpc_id          = module.vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name = "/aws/vpc/flow-logs-${module.vpc.vpc_id}"
}

resource "aws_iam_role" "flow_logs" {
  name = "flow-logs-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "vpc" {
  name                          = "vpc-cloudtrail"
  s3_bucket_name                = "my-bucket-name" # replace with your S3 bucket name
  s3_key_prefix                 = "cloudtrail-logs"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name = "/aws/cloudtrail/${aws_cloudtrail.vpc.name}"
}

resource "aws_iam_role" "cloudtrail" {
  name = "cloudtrail-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "flow_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonVPCFlowLogsRole"
  roles      = [aws_iam_role.flow_logs.name]
}

resource "aws_iam_policy_attachment" "cloudtrail" {
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSCloudTrailServiceRolePolicy"
  roles      = [aws_iam_role.cloudtrail.name]
}
