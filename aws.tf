  
provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::573329840855:role/AccessLyon"
  }
}

# Create a VPC
#resource "aws_vpc" "sma-example" {
#  cidr_block = "10.70.0.0/16"
#}

#resource "aws_key_pair" "BVA-Key" {
#  key_name    = "BVA-Key"
#  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCLIIYmGSvZCTtwrCKUIlf4PJ7qrA5jCQ4xG9W2FTJ4u7i5szo2ygwwyAsd/fW9rl/vBTKZWJLexw8awn2Vw9i+LeAb7HjAqStaA4IAyJLDIJ5PT1pQN5yUHx+3QnEgGLcSoW5xJMDbZCm8NH+jvFDhHW7CZlS3Tc2JQlFcLJ4zTeOnhVpKRdoGYeey8pJs1WHjnyJGZTIW36eW8uX1fsGZFQ8XShI4vj8KOinK6jnGwWdpzf3Rp5+O/VpgEfKdr8vmr69guluYjGgAXjPyIniUhFT0AqARZq3XIrIAG6SVzH9RJUpfAyfqe7qpKc4yLiF9eB6BgKW6KQ/dU0kMy2jZ"
#}




resource "aws_instance" "test-EC2-in-VPC" {
  ami                    = "ami-007fae589fdf6e955" #id of desired AMI
  instance_type          = "t2.small"
  subnet_id              = "subnet-0599b65bdbcc15355"
  key_name               = "SMA-KEY"
  tags = {
    Name = "EC2-test"
  }

  resource "aws_security_group" "allow_tls" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
  }
  tags = {
    Name = "allow_all"
  }
}
}

