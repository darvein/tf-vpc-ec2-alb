#data "aws_availability_zones" "azs" {
#state = "available"
#}

data "aws_ami" "ubuntu20" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#data "aws_subnet_ids" "public" {
#vpc_id = aws_vpc.vpc.id
#tags   = { Tier = "public" }
#}

#data "aws_subnet_ids" "private" {
#vpc_id = aws_vpc.vpc.id
#tags   = { Tier = "private" }
#}

data "template_file" "user_data" {
  template = file("templates/provisioner.sh.tpl")
}
