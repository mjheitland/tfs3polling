#--- root/main.tf ---
provider "aws" {
  region = "eu-west-1"
}

# region
data "aws_region" "current" {}

# account information
data "aws_caller_identity" "current" {}

# deploy storage resources
module "storage" {
  source = "./storage"
  
  bucket = "tfs3polling-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  tags = {
    "project-name": var.project_name
  }
}

# deploy networking resources
#module "networking" {
#  source        = "./networking"
#  
#  project_name  = var.project_name
#}

# deploy compute resources
#module "compute" {
#  source          = "./compute"
#  
#  project_name    = var.project_name
#  key_name        = var.key_name
#  public_key_path = var.public_key_path
#
#  vpc1_id         = module.networking.vpc1_id
#  subprv1_id      = module.networking.subprv1_id
#  sgprv1_id       = module.networking.sgprv1_id
#}
