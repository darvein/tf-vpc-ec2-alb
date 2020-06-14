locals {
  general_tags = {
    "Terraform-Managed" = "True"
  }

  outside_cidr = "0.0.0.0/0"

  subnet_a = cidrsubnet(var.vpc_cidr, 2, 0) # /26 - 25%
  subnet_b = cidrsubnet(var.vpc_cidr, 2, 1) # /26 - 25%
  subnet_c = cidrsubnet(var.vpc_cidr, 1, 1) # /25 - 50%

  public_subnets  = [local.subnet_a, local.subnet_b]
  private_subnets = [local.subnet_c]
}
