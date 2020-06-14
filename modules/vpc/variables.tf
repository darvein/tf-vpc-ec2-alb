variable "name" { default = "" }
variable "vpc_cidr" { default = "" }

variable "enable_dns_support" { default = true }
variable "enable_dns_hostnames" { default = true }
variable "enable_classiclink" { default = true }

variable "general_tags" {}

variable "public_subnets" { type = list }
variable "private_subnets" { type = list }

variable "subnet_a" { default = "" }
variable "subnet_b" { default = "" }
variable "subnet_c" { default = "" }
