variable "name" { default = "" }

variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }

variable "general_tags" {}

variable "public_subnet_ids" {}

variable "web_sg_id" { default = "" }

variable "web_instances_ids" {}
