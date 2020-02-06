data "aws_ami" "eks-worker" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.eks.version}-v*"]
   }

   most_recent = true
   owners      = ["573329840855"] # Amazon EKS AMI Account ID
 }