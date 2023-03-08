output "vpc_id" {
  value = aws_vpc.main.id
}


output "region" {
  value = var.region
}


# output "public_subnets_ids" {
#   value = var.public_subnets.subnet_ids
# }

# output "private_subnets_ids" {
#   value = var.private_subnets.subnet_ids
# }