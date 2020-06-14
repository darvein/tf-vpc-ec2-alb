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

output "public_subnet_cidrs" {
  value = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnet_cidrs" {
  value = [for s in aws_subnet.private : s.cidr_block]
}
