#!/bin/bash
sudo su -
sudo yum update
sudo yum -y python3-pip
sudo pip3 install boto3
sudo pip3 install botocore
sudo adduser koventhan 
PASSWD=”Secret1.0” 
sudo echo ${PASSWD} | passwd –stdin ansible
echo “koventhan ALL=(ALL)   NOPASSWD:ALL” >> /etc/sudoers
sudo sed –i ‘/PasswordAuthentication yes/s/^#//’ /etc/ssh/sshd_config
sudo sed –i “s/PasswordAuthentication no/#PasswordAuthentication no/g” /etc/ssh/sshd_config
sudo service sshd restart 