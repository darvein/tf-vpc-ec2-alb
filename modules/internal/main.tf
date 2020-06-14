### Data

data "aws_vpc" "vpc" {
  id = var.vpc_id
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
    for_each = var.quake_arena_ports
    content {
      protocol        = "tcp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [var.web_sg_id]
      description     = format("Quake III Arena %d/TCP", ingress.value)
    }
  }

  dynamic "ingress" {
    for_each = var.quake_arena_ports
    content {
      protocol        = "udp"
      to_port         = ingress.value
      from_port       = ingress.value
      security_groups = [var.web_sg_id]
      description     = format("Quake III Arena %d/UDP", ingress.value)
    }
  }

  ingress {
    to_port     = var.ssh_port
    from_port   = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_sg_access_cidr]
    description = "SSH Access to the VPCs CIDR"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.general_tags,
    { Name = format("%s-sg-web", var.name) }
  )
}

