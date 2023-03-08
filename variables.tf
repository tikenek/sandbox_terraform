variable "availability_zones" {
  description = "Availability zones to use for subnets"
  type        = list(string)
}

variable "cidr_block" {
  type = string
}

variable "region" {
  type = string
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
  description = "A list of private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks"
  type        = list(string)
}
