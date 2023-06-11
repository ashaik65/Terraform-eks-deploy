resource "aws_eks_cluster" "eks_cluster" {
  name     = format("${var.env}-cluster")
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.25"
  vpc_config {
    security_group_ids      = [aws_security_group.AdditionalSecurityGroup.id]
    subnet_ids              = [data.aws_subnet.pvt1.id, data.aws_subnet.pvt2.id, data.aws_subnet.pvt3.id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }
  tags = merge(
    var.additional_tags,
  )
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}

resource "aws_iam_openid_connect_provider" "eksOidcProvider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}