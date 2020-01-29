resource "aws_security_group_rule" "tf-eks-master-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server."
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.tf-eks-master.id
  to_port           = 443
  type              = "ingress"
}
resource "aws_security_group_rule" "tf-eks-node-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the Kubernetes nodes directly."
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.tf-eks-nodes.id
  to_port           = 22
  type              = "ingress"
}
