output "id" {
  value = aws_vpc.vpc.id
}

output "cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "public_subnet_ids" {
  value = tolist(aws_subnet.public.*.id)
}

output "private_subnet_ids" {
  value = tolist(aws_subnet.private.*.id)
}
