# Setup data source to get amazon-provided AMI for EKS nodes
data "aws_ami" "eks-worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }
 
  most_recent = true
  owners      = ["573329840855"] # Amazon EKS AMI Account ID
}
# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' '${var.eks_cluster-name}'
USERDATA
}
 
resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks"
  security_groups             = ["${aws_security_group.tf-eks-node.id}"]
  user_data_base64            = "${base64encode(local.tf-eks-node-userdata)}"
  key_name                    = "${var.keypair-name}"
 
  lifecycle {
    create_before_destroy = true
  }
}