################################################################################
# Private subnets list
################################################################################

output "private_subnets_id" {
  value = aws_subnet.subnet_private[*].id
}