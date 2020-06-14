variable "name" { default = "" }

variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }
variable "key_name" { default = "" }
variable "ami" { default = "" }

variable "general_tags" {}

variable "internal_instances_number" { default = 0 }
variable "internal_instances_type" { default = "" }

variable "private_subnet_ids" {}

variable "web_sg_id" { default = "" }
