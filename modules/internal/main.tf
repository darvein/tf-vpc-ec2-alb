### Locals

locals {
  outside_cidr      = "0.0.0.0/0"
  quake_arena_ports = [27950, 27952, 27960, 27965]
}

### Internal

resource "aws_instance" "internal" {
  count = var.internal_instances_number

  ami           = var.ami
  instance_type = var.internal_instances_type
  key_name      = var.key_name

  subnet_id = element(var.private_subnet_ids, count.index)

  vpc_security_group_ids = [aws_security_group.internal.id]

  tags = merge(
    var.general_tags,
    { Name = format("%s-internal-%d", var.name, count.index) }
  )
}

resource "aws_security_group" "internal" {
  name        = format("%s-internal-sg", var.name)
  description = "internal servers security group"

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.quake_arena_ports
    content {
      protocol        = "tcp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [var.web_sg_id]
      description     = format("Quake III Arena %d", ingress.value)
    }
  }

  dynamic "ingress" {
    for_each = local.quake_arena_ports
    content {
      protocol        = "udp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [var.web_sg_id]
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

