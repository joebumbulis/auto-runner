variable "instance_type" {
  description = "The name of the EC2 instance type"
  default = "t2.micro"
}

variable "key_name" {
  description = "The name of key pair you want to utilize"
}

variable "vm_name" {
  description = "The name of VM you want to provision"
}

variable "owner_name" {
  description = "The name of owner of the VM being provisioned"
}