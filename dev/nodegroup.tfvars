AWS_REGION           = "ap-south-1"
env                  = "dev"
project              = "anisLearning"
eks_cluster_name     = "dev-cluster"
key_name             = "kubeadm"
desired_capacity     = 1
min_size             = 1
max_size             = 6
ebs_volume_size      = 20
ebs_volume_type      = "gp2"
capacityType         = "ON_DEMAND"
onDemandInstanceType = ["t3a.medium"]
spotInstanceType     = ["t3.medium", "t2.medium", "t3a.medium", "t3a.large", "t3.large", "t2.large", "m5a.large", "m5.large", "c5a.large", "c5.large", ]

additional_tags = {
  environment                       = "dev"
  Owner                             = "Anis"
  role                              = "eksworkernode"
}
ingress_rules = [
  { from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_block  = "10.124.0.0/19"
    description = "Allow all UDP traffic for internal communication"
  },
  { from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_block  = "10.124.0.0/19"
    description = "Allow all TCP traffic for internal communication"
  }
]