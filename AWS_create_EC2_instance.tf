resource "aws_instance" "test-EC2" {
  ami                    = "ami-007fae589fdf6e955" #id of desired AMI
  instance_type          = "t2.small"
  subnet_id              = "subnet-0599b65bdbcc15355"
  key_name               = "SMA-KEY"
  tags = {
    Name = "EC2-test"
  }
}

#Configuration des Outputs
output "public_ip" {
  value       = "${aws_instance.test-EC2-in-VPC.public_ip}"
  description = "The private IP address of the main server instance."
}

