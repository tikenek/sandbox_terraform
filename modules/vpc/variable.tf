variable "cidr_block" {
  description = "CIDR block for the VPC"
}

variable "region" {
  description = "Region for the VPC"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}


variable "private_subnets_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "list(string)"
}

variable "public_subnets" {
  description = "list(string)"
}

variable "availability_zones" {
  description = "Availability zones to use for subnets"
  type        = list(string)
}

