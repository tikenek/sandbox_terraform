module "vpc" {
  source               = "./modules/vpc"
  availability_zones   = var.availability_zones
  cidr_block           = var.cidr_block
  region               = var.region
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
}
