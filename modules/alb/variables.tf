variable "name" { default = "" }

variable "vpc_id" { default = "" }
variable "vpc_cidr" { default = "" }

variable "web_sg_id" { default = "" }
variable "public_subnet_ids" {}
variable "web_instances_ids" {}

variable "app_port" { default = 80 }
variable "alb_listener_port" { default = 80 }
variable "app_health_check_path" { default = "/" }

variable "alb_check_interval" { default = 30 }
variable "alb_check_timeout" { default = 10 }
variable "alb_threshold_healty" { default = 3 }
variable "alb_threshold_unhealty" { default = 3 }

variable "general_tags" {}
