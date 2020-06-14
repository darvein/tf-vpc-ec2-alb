variable "aws_region" { default = "" }

variable "vpc_cidr" { default = "" }
variable "project_name" { default = "" }

variable "ssh_port" { default = 22 }
variable "app_port" { default = 80 }
variable "app_health_check_path" { default = "/status.html" }
variable "alb_listener_port" { default = 80 }

variable "web_instances_number" { default = 0 }
variable "web_instances_type" { default = "" }

variable "internal_instances_number" { default = 0 }
variable "internal_instances_type" { default = "" }

variable "quake_arena_ports" { default = [27950, 27952, 27960, 27965] }

variable "alb_check_interval" { default = 30 }
variable "alb_check_timeout" { default = 10 }
variable "alb_threshold_healty" { default = 3 }
variable "alb_threshold_unhealty" { default = 3 }
