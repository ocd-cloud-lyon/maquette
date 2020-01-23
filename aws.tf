provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::573329840855:role/AccessLyon"
  }
}

# Create a VPC
#resource "aws_vpc" "sma-example" {
#  cidr_block = "10.70.0.0/16"
#}

resource "aws_instance" "test-EC2 in VPC" {
  ami                    = "ami-007fae589fdf6e955" #id of desired AMI
  instance_type          = "t2.small"
  subnet_id              = "subnet-0599b65bdbcc15355"
}

