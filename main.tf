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

# TODO : check security groups improvements
module "web" {
  source = "./modules/web"

  name = var.project_name

  vpc_id   = module.vpc.id
  vpc_cidr = var.vpc_cidr # TODO no need to send this
  ami      = data.aws_ami.ubuntu20.id
  key_name = aws_key_pair.keypair.key_name

  web_instances_type   = var.web_instances_type
  web_instances_number = var.web_instances_number

  public_subnet_ids = module.vpc.public_subnet_ids

  general_tags = local.general_tags
}


# TODO : check security groups improvements
module "internal" {
  source = "./modules/internal"

  name = var.project_name

  vpc_id   = module.vpc.id
  vpc_cidr = var.vpc_cidr # TODO no need to send this
  ami      = data.aws_ami.ubuntu20.id
  key_name = aws_key_pair.keypair.key_name

  internal_instances_type   = var.internal_instances_type
  internal_instances_number = var.internal_instances_number

  private_subnet_ids = module.vpc.private_subnet_ids

  general_tags = local.general_tags

  web_sg_id = module.web.sg_id
}


# TODO Check the harcoded ports and healtcheck path
module "alb" {
  source = "./modules/alb"

  name              = var.project_name
  vpc_id            = module.vpc.id
  vpc_cidr          = var.vpc_cidr # TODO no need to send this
  public_subnet_ids = module.vpc.public_subnet_ids
  web_sg_id         = module.web.sg_id
  web_instances_ids = module.web.instances_ids

  general_tags = local.general_tags
}
