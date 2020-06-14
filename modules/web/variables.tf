variable "name" { default = "" }

variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }
variable "key_name" { default = "" }
variable "ami" { default = "" }

variable "general_tags" {}

variable "web_instances_number" { default = 0 }
variable "web_instances_type" { default = "" }

variable "public_subnet_ids" {}
