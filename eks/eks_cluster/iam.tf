resource "aws_iam_role" "eks_cluster" {
  name               = format("${var.env}-eks-cluster")
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "eks.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

#------------------WorkerNodeGroupRole

resource "aws_iam_role" "WorkerNodeGroupRole" {
  name               = "${var.env}-WorkerNodeGroupRole"
  tags               = merge(var.additional_tags)
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF  
}
resource "aws_iam_role_policy_attachment" "WorkerNodeGroupPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.WorkerNodeGroupRole.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.WorkerNodeGroupRole.name
}
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.WorkerNodeGroupRole.name
}
resource "aws_iam_instance_profile" "WorkerNodeGroupProfile" {
  name = "${var.env}-cluster-WorkerNodegroup-profile"
  role = aws_iam_role.WorkerNodeGroupRole.id
  tags = merge(var.additional_tags)
}

resource "aws_iam_policy" "sendemail" {
  name        = "${var.env}-cluster-sendmail-policy"
  description = "Send email from eks app"
  policy      = <<EOF
{
    "Statement": [
        {
            "Action": [
                "ses:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF 
}
resource "aws_iam_policy_attachment" "send-email" {
  name       = "sendEmailPolicy"
  roles      = [aws_iam_role.WorkerNodeGroupRole.name]
  policy_arn = aws_iam_policy.sendemail.arn
}

#-------------------ClusterAutoscaling---------------
resource "aws_iam_policy" "ClusterAutoscalerPolicy" {
  name        = "${var.env}-cluster-AutoscalerPolicy"
  path        = "/"
  description = "Policy for cluster autoscaler service"
  policy      = file("${path.module}/cluster-autoscaler-policy.json")
}

data "aws_iam_policy_document" "kubernetes_cluster_autoscaler_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eksOidcProvider.id]
    }
    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eksOidcProvider.url}:sub"
      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler",
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "ClusterAutoscalerRole" {
  name               = "${var.env}-cluster-AutoscalerRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_cluster_autoscaler_assume.json
}
resource "aws_iam_policy_attachment" "ClusterAutoscalerAttachment" {
  name       = "ClusterAutoscalerPolicy"
  roles      = [aws_iam_role.ClusterAutoscalerRole.name]
  policy_arn = aws_iam_policy.ClusterAutoscalerPolicy.arn
}

#-----------------------AmazonEKSLoadBalancerControllerRole-----
resource "aws_iam_policy" "ClusterAlbControllerPolicy" {
  name        = "${var.env}-cluster-AlbControllerPolicy"
  path        = "/"
  description = "Policy for aws load balancer Controller"
  policy      = file("${path.module}/cluster-albController-policy.json")
}

data "aws_iam_policy_document" "kubernetes_cluster_alb_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eksOidcProvider.id]
    }
    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eksOidcProvider.url}:sub"
      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller",
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eksOidcProvider.url}:aud"
      values = [
        "sts.amazonaws.com",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ClusterAlbControllerRole" {
  name               = "${var.env}-cluster-AlbControllerRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_cluster_alb_assume.json
}
resource "aws_iam_policy_attachment" "ClusterAlbControllerAttachment" {
  name       = "ClusterAlbControllerPolicy"
  roles      = [aws_iam_role.ClusterAlbControllerRole.name]
  policy_arn = aws_iam_policy.ClusterAlbControllerPolicy.arn
}

#-----------------------AmazonEKSExternalDnsRole-----
resource "aws_iam_policy" "ClusterExternalDnsPolicy" {
  name        = "${var.env}-cluster-ExternalDnsPolicy"
  path        = "/"
  description = "Policy for aws load balancer Controller"
  policy      = file("${path.module}/cluster-externalDns-policy.json")
}

data "aws_iam_policy_document" "kubernetes_cluster_externalDns_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eksOidcProvider.id]
    }
    condition {
      test     = "StringEquals"
      variable = "${aws_iam_openid_connect_provider.eksOidcProvider.url}:sub"
      values = [
        "system:serviceaccount:default:external-dns",
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "ClusterExternalDnsRole" {
  name               = "${var.env}-cluster-ExternalDnsRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_cluster_externalDns_assume.json
}
resource "aws_iam_policy_attachment" "ClusterExternalDnsAttachment" {
  name       = "ClusterExternalDnsPolicy"
  roles      = [aws_iam_role.ClusterExternalDnsRole.name]
  policy_arn = aws_iam_policy.ClusterExternalDnsPolicy.arn
}

