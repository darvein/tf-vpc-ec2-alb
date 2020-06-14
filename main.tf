locals {
  subnet_a = cidrsubnet(var.vpc_cidr, 2, 0) # mask /26 - 25% IPs
  subnet_b = cidrsubnet(var.vpc_cidr, 2, 1) # mask /26 - 25% IPs
  subnet_c = cidrsubnet(var.vpc_cidr, 1, 1) # mask /25 - 50% IPs

  public_subnets  = [local.subnet_a, local.subnet_b]
  private_subnets = [local.subnet_c]

  outside_cidr      = "0.0.0.0/0"
  quake_arena_ports = [27950, 27952, 27960, 27965]
  general_tags = {
    "Terraform" = 1
    "Project"   = var.project_name
  }
}

module "vpc" {
  source = "./modules/vpc"
  name   = var.project_name

  vpc_cidr        = var.vpc_cidr
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  subnet_a = local.subnet_a
  subnet_b = local.subnet_b
  subnet_c = local.subnet_c

  general_tags = local.general_tags
}

module "web" {
  source = "./modules/web"
  name   = var.project_name

  ami               = data.aws_ami.ubuntu20.id
  vpc_id            = module.vpc.id
  key_name          = aws_key_pair.keypair.key_name
  public_subnet_ids = module.vpc.public_subnet_ids

  web_instances_type   = var.web_instances_type
  web_instances_number = var.web_instances_number

  app_port           = var.app_port
  ssh_port           = var.ssh_port
  ssh_sg_access_cidr = var.vpc_cidr
  app_sg_access_cidr = local.outside_cidr

  general_tags = local.general_tags
}


module "internal" {
  source = "./modules/internal"
  name   = var.project_name

  ami                = data.aws_ami.ubuntu20.id
  vpc_id             = module.vpc.id
  key_name           = aws_key_pair.keypair.key_name
  private_subnet_ids = module.vpc.private_subnet_ids

  internal_instances_type   = var.internal_instances_type
  internal_instances_number = var.internal_instances_number

  ssh_port           = var.ssh_port
  web_sg_id          = module.web.sg_id
  quake_arena_ports  = var.quake_arena_ports
  ssh_sg_access_cidr = var.vpc_cidr

  general_tags = local.general_tags
}


module "alb" {
  source = "./modules/alb"
  name   = var.project_name

  vpc_id            = module.vpc.id
  web_sg_id         = module.web.sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  web_instances_ids = module.web.instances_ids

  app_port              = var.app_port
  alb_listener_port     = var.alb_listener_port
  app_health_check_path = var.app_health_check_path

  alb_check_interval     = var.alb_check_interval
  alb_check_timeout      = var.alb_check_timeout
  alb_threshold_healty   = var.alb_threshold_healty
  alb_threshold_unhealty = var.alb_threshold_unhealty

  general_tags = local.general_tags
}
