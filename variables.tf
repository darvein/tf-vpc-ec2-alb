variable "aws_region" { default = "us-west-2" }

variable "project_name" { default = "demo" }
variable "vpc_cidr" { default = "10.10.10.0/24" }

variable "enable_dns_support" { default = true }
variable "enable_dns_hostnames" { default = true }
variable "enable_classiclink" { default = true }

variable "web_instances_number" { default = 2 }
variable "web_instances_type" { default = "t3.small" }

variable "internal_instances_number" { default = 1 }
variable "internal_instances_type" { default = "t3.small" }
