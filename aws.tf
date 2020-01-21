provider "aws" {}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.70.0.0/16"
}
