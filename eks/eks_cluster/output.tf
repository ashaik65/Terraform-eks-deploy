output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = try(aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id, "")
}
output "AdditionalSecurityGroup" {
  value = aws_security_group.AdditionalSecurityGroup.id
}
output "clusterArn" {
  value = aws_eks_cluster.eks_cluster.arn
}
output "CertificateAuthorityData" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}
output "ServiceRoleARN" {
  value = aws_iam_role.eks_cluster.arn
}
output "OidcProviderID" {
  value = aws_iam_openid_connect_provider.eksOidcProvider.url
}