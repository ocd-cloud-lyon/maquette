resource "aws_eks_cluster" "tf_eks" {
  name            = "example-cluster"
  role_arn        = "${aws_iam_role.tf-eks-master.arn}"
  vpc_config {
    security_group_ids = ["${aws_security_group.tf-eks-master.id}"]
    subnet_ids         = ["subnet-0c187777047b53659", "subnet-074eabb40ef5b6128"]
  }
  depends_on = [
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.tf-cluster-AmazonEKSServicePolicy",
  ]
}
