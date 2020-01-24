resource "aws_iam_role" "eks_iam_role" {
  name = "eks_iam_role"

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
    }
  ]
}
EOF
#Sid = statement de la règle 
  #Problèle de }
}
