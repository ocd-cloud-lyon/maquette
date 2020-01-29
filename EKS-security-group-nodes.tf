resource "aws_security_group" "tf-eks-nodes" {
    name        = "terraform-eks-nodes"
    description = "Security group for all nodes"
    vpc_id      = "vpc-03cca642ef84627e2"
      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      tags {
        "Name" : "terraform-eks"
      }
}