resource "aws_ssm_parameter" "EKSClusterName" {
  name  = "/eks/clustername"
  value = aws_eks_cluster.eks_cluster.name
  type  = "String"
}
resource "aws_ssm_parameter" "workernodegroupProfile" {
  name  = "/iam/roles/workernodegroupProfile"
  type  = "String"
  value = aws_iam_instance_profile.WorkerNodeGroupProfile.arn
}
resource "aws_ssm_parameter" "WorkerNodeGroupRole" {
  name  = "/iam/roles/WorkerNodeGroupRole"
  type  = "String"
  value = aws_iam_role.WorkerNodeGroupRole.arn
}
resource "aws_ssm_parameter" "EKSClusterRoleArn" {
  name  = "/iam/roles/EKSClusterRoleArn"
  type  = "String"
  value = aws_iam_role.eks_cluster.arn
}
resource "aws_ssm_parameter" "EKSExternalDnsRole" {
  name  = "/iam/roles/EKSExternalDnsRole"
  type  = "String"
  value = aws_iam_role.ClusterExternalDnsRole.arn
}
resource "aws_ssm_parameter" "EKSClusterAutoscalerRole" {
  name  = "/iam/roles/EKSClusterAutoscalerRole"
  type  = "String"
  value = aws_iam_role.ClusterAutoscalerRole.arn
}
resource "aws_ssm_parameter" "EKSClusterAlbControllerRole" {
  name  = "/iam/roles/EKSClusterAlbControllerRole"
  type  = "String"
  value = aws_iam_role.ClusterAlbControllerRole.arn
}