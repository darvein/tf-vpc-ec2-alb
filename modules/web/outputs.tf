output "sg_id" {
  value = aws_security_group.web.id
}

output "instances_ids" {
  value = tolist(aws_instance.web.*.id)
}
