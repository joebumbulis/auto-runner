variable "region" {
  description = "The region Terraform deploys your instance"
  default = "us-east-2"
}

variable "profile" {
  description = "The profile you want to use in your credentials file"
}

variable "instance_type" {
  description = "The name of the EC2 instance type"
  default = "t2.micro"
}

variable "key_name" {
  description = "The name of key pair you want to utilize"
}