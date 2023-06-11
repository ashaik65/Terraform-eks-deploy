data "aws_eks_cluster" "selected" {
  name = var.eks_cluster_name
}
data "aws_ami" "selected_eks_optimized_ami" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-${data.aws_eks_cluster.selected.version}*"]
  }
}