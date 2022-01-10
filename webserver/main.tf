
module "myvpc" {
  source      = "../modules/vpc"
  location    = "us-east-2"
  cidr_block  = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  env         = "Production"
}

module "keypair" {
  source          = "../modules/ssh"
  public_key_path = "/home/koventhan/.ssh/id_rsa.pub"
  keypair_region  = "us-east-2"

}

/*
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]


  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}*/

resource "aws_network_interface" "ethernet" {
  subnet_id       = module.myvpc.subnet.id
  security_groups = [module.myvpc.security_group.id]

}

# Elastic Ip for connecting to the server 
resource "aws_eip" "elasticip" {
  vpc               = true
  network_interface = aws_network_interface.ethernet.id
  depends_on        = [module.myvpc.internet_gateway]

}

resource "aws_instance" "meanstack" {
  ami                         = "ami-002068ed284fb165b"
  instance_type               = var.instancesize
  subnet_id                   = module.myvpc.subnet.id
  vpc_security_group_ids      = [module.myvpc.security_group.id]
  associate_public_ip_address = true
  key_name                    = module.keypair.keyname
  tags = {
    "Name" = "${var.env}-ec2"
  }

user_data = <<EOF
#!/bin/bash
sudo su -
sudo yum update
sudo yum -y python3-pip
sudo pip3 install boto3
sudo pip3 install botocore
sudo adduser koventhan 
sudo echo ”Secret1.0” | passwd –stdin ansible
echo “koventhan ALL=(ALL)   NOPASSWD:ALL” >> /etc/sudoers
sudo sed –i ‘/PasswordAuthentication yes/s/^#//’ /etc/ssh/sshd_config
sudo sed –i “s/PasswordAuthentication no/#PasswordAuthentication no/g” /etc/ssh/sshd_config
sudo service sshd restart 
EOF

#}

/*
resource "null_resource" "command" {

  depends_on = [
    aws_instance.meanstack,
  ]
  provisioner "remote-exec" {
    inline = [
      "sudo su - ",
      #"apt update",

      "apt install -y python3-pip",
    ]
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = module.keypair.keyname
    host     = aws_instance.meanstack.public_ip

  }
  */
/*  
  provisioner "local-exec" {
    command = <<EOF
  aws ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id} 
  ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' /home/koventhan/Desktop/Terraform/webserver/playbook.yaml  
  EOF
  }
  */

}


