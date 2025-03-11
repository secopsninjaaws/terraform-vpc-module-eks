output "aws_subnet_public_ids" {
  value = aws_subnet.public.*.id
  
}

output "aws_subnet_private_ids" {
  value = aws_subnet.private.*.id
  
}