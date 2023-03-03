# variable "vpc_cidr" {
#   type = string
# }

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

variable "public_subnets" {
  type = list(object({
    id         = string
    cidr_block = string
  }))
}

variable "private_subnets" {
  type = list(object({
    id         = string
    cidr_block = string
  }))
}
