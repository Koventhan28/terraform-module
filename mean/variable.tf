variable "instancesize" {
  default = "t2.micro"
}
variable "env" {
  default = "Production"
}
variable "profile" {
  type    = string
  default = "default"
}
variable "region" {
  default = "us-east-2"
}

variable "North_Virginia" {
  default = "us-east-2"
} 
variable "PASSWD" {
  type = string
  default = "Secret1.0"
  description = "(optional) describe your variable"
}