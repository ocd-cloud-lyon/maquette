#On parle de l'Output du VPC
output "vpc_id" {
  value = aws_vpc.example.id
}

#Ici, on parle de l'output du Kubeconfig
output "eks_kubeconfig" {
  value = "${local.kubeconfig}"
  depends_on = [
    "aws_eks_cluster.tf_eks"
  ]
}
