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

# project/terraform_workspace/platform_environment/terraform/modules/vpc/vpc_new

# module "vpc_new" {
#   source              = "./modules/vpc/vpc_new"
#   region              = "us-east-1"
#   cidr_block          = "10.0.0.0/16"
#   availability_zones  = ["us-east-1a", "us-east-1b"]
#   public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
#   public_subnets       = ["public-subnet-1", "public-subnet-2"]
#   private_subnets      = ["private-subnet-1", "private-subnet-2"]
# }
