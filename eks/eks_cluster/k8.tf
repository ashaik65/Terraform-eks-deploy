provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  #   load_config_file       = false
}


resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  # data = {
  #     mapRoles = <<YAML
  # - rolearn: ${aws_iam_role.WorkerNodeGroupRole.arn}
  #   username: system:node:{{EC2PrivateDNSName}}
  #   groups:
  #     - system:bootstrappers
  #     - system:nodes      
  #   YAML
  #   }
  data = {
    mapRoles = yamlencode(
      [
        {
          rolearn  = "${aws_iam_role.WorkerNodeGroupRole.arn}"
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = ["system:masters", "system:nodes"]
        },
      ]
    )
    mapUsers = yamlencode(
      [
        {
          userarn  = "arn:aws:iam::312816102899:user/rohan-patil"
          username = "eks-admin"
          groups   = ["system:masters"]
        },
      ]
    )
  }
}
    