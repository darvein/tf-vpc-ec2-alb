variable "name" { default = "" }

variable "ami" { default = "" }
variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }
variable "key_name" { default = "" }

variable "internal_instances_number" { default = 0 }
variable "internal_instances_type" { default = "" }

variable "web_sg_id" { default = "" }
variable "private_subnet_ids" {}
variable "ssh_port" { default = 22 }
variable "ssh_sg_access_cidr" { default = "" }

variable "quake_arena_ports" {
  default = [27950, 27952, 27960, 27965]
}

variable "general_tags" {}
