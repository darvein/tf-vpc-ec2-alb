module "vpc" {
  source = "./modules/vpc"

  name     = var.project_name
  vpc_cidr = var.vpc_cidr

  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  subnet_a = local.subnet_a
  subnet_b = local.subnet_b
  subnet_c = local.subnet_c

  general_tags = local.general_tags
}
