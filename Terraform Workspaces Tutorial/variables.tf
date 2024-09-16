variable "region" {
    description = "The name of the aws region"
    type = string
    default = "us-east-1"
}

variable "ami" {
    description = "The ami-id of the Amazon Machine Image that we are uing"
    type = string
    default = "ami-0e86e20dae9224db8"
}

variable "instance_type" {
  description = "The tyep of the EC2 isntance that we are using"
  type = string
  default = "t2.micro"
}