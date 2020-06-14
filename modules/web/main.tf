### Data

data "template_file" "user_data" {
  template = file("${path.module}/templates/provisioner.sh.tpl")
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

### Web resources 

resource "aws_instance" "web" {
  count = var.web_instances_number

  ami           = var.ami
  instance_type = var.web_instances_type
  key_name      = var.key_name
  user_data     = data.template_file.user_data.rendered

  subnet_id = element(var.public_subnet_ids, count.index)

  vpc_security_group_ids = [aws_security_group.web.id]

  tags = merge(
    var.general_tags,
    { Name = format("%s-web-%d", var.name, count.index) }
  )
}

resource "aws_security_group" "web" {
  name        = format("%s-web-sg", var.name)
  description = "Web servers security group"

  vpc_id = var.vpc_id

  ingress {
    to_port     = var.ssh_port
    from_port   = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.ssh_sg_access_cidr]
    description = "SSH open to the VPCs CIDR"
  }

  ingress {
    to_port     = var.app_port
    from_port   = var.app_port
    protocol    = "tcp"
    cidr_blocks = [var.app_sg_access_cidr]
    description = "HTTP open to the world"
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
