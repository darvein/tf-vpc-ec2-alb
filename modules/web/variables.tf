variable "name" { default = "" }

variable "ami" { default = "" }
variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }
variable "key_name" { default = "" }
variable "public_subnet_ids" {}

variable "app_port" { default = 80 }
variable "ssh_port" { default = 22 }
variable "app_sg_access_cidr" { default = "" }
variable "ssh_sg_access_cidr" { default = "" }


variable "web_instances_number" { default = 0 }
variable "web_instances_type" { default = "" }

variable "general_tags" {}
