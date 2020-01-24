resource "aws_iam_role" "EKS_IAM_role" {
  name = "EKS_IAM_role"

  assume_role_policy = <<EOF
{
  "Version": "2020-01-24",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "" 
    }
  ]
}
EOF
#Sid = statement de la règle 
}
