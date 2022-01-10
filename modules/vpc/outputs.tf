output "subnet" {
    value = aws_subnet.subnet
}

output "security_group" {
   value = aws_security_group.allow_ssh
}
output "internet_gateway" {
    value = aws_internet_gateway.igw
}
