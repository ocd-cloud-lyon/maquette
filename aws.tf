provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::573329840855:role/AccessLyon"
  }
}

# Create a VPC
#resource "aws_vpc" "sma-example" {
#  cidr_block = "10.70.0.0/16"
#}

resource "aws_default_security_group" "default" {
   vpc_id      = "vpc-03cca642ef84627e2"
 ingress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     # Please restrict your ingress to only necessary IPs and ports.
     # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
     cidr_blocks     = ["0.0.0.0/0"]
   }
 egress {
     from_port       = 0
     to_port         = 0
     protocol        = "-1"
     cidr_blocks     = ["0.0.0.0/0"]
   }
 }


resource "aws_instance" "test-EC2-in-VPC" {
  ami                    = "ami-007fae589fdf6e955" #id of desired AMI
  instance_type          = "t2.small"
  subnet_id              = "subnet-0599b65bdbcc15355"
  key_name               = "SMA-KEY"
  tags = {
    Name = "EC2-test"
  }
}

