#output "alb_dns" {
#value = aws_lb.alb.dns_name
#}

output "vpc_id" {
  value = module.vpc.id
}
