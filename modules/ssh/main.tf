resource "aws_key_pair" "Webserver-key" {
  key_name   = "deployer-key"
  public_key = file("${var.public_key_path}")
  tags = {
    Name = "Webserver-key"
  }
}