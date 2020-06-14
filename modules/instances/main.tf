## WEB

resource "aws_instance" "web" {
  count = var.web_instances_number

  ami           = data.aws_ami.ubuntu20.id
  instance_type = var.web_instances_type
  key_name      = aws_key_pair.keypair.key_name
  user_data     = data.template_file.user_data.rendered

  subnet_id = element(sort(data.aws_subnet_ids.public.ids), count.index)

  vpc_security_group_ids = [aws_security_group.web.id]

  tags = merge(
    local.general_tags,
    { Name = format("%s-web-%d", var.project_name, count.index) }
  )
}

resource "aws_security_group" "web" {
  name        = format("%s-web-sg", var.project_name)
  description = "Web servers security group"

  vpc_id = aws_vpc.vpc.id

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "SSH open to the VPCs CIDR"
  }

  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = [local.outside_cidr]
    description = "HTTP open to the world"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = [local.outside_cidr]
  }
}

### Internal

locals {
  quake_arena_ports = [27950, 27952, 27960, 27965]
}

resource "aws_instance" "internal" {
  count = var.internal_instances_number

  ami           = data.aws_ami.ubuntu20.id
  instance_type = var.internal_instances_type
  key_name      = aws_key_pair.keypair.key_name
  user_data     = data.template_file.user_data.rendered

  subnet_id = element(sort(data.aws_subnet_ids.private.ids), count.index)

  vpc_security_group_ids = [aws_security_group.internal.id]

  tags = merge(
    local.general_tags,
    { Name = format("%s-internal-%d", var.project_name, count.index) }
  )
}

resource "aws_security_group" "internal" {
  name        = format("%s-internal-sg", var.project_name)
  description = "internal servers security group"

  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.quake_arena_ports
    content {
      protocol        = "tcp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [aws_security_group.web.id]
      description     = format("Quake III Arena %d", ingress.value)
    }
  }

  dynamic "ingress" {
    for_each = local.quake_arena_ports
    content {
      protocol        = "udp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [aws_security_group.web.id]
      description     = format("Quake III Arena %d", ingress.value)
    }
  }

  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "SSH Access to the VPCs CIDR"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = [local.outside_cidr]
  }
}

