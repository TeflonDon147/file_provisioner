output "public_ip" {
  value = aws_instance.teflon.public_ip
}

output "private_ip" {
  value = aws_instance.teflon.private_ip
}

output "aws_eip" {
  value = aws_eip.ip.public_ip
}