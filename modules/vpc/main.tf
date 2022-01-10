#VPC
##subnet
#iG
#RT
#RTA

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
  tags = {
      Name = "${var.env}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "${var.env}-subnet-1"
  }
  
}
# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}
# Create Custom Route Table 
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
       Name = "${var.env}-rt"
  }
}

# Create a route table association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.routetable.id 
}

# Security Groups
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}