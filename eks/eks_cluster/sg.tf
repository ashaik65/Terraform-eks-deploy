resource "aws_security_group" "AdditionalSecurityGroup" {
  name        = format("${var.env}-controllerplaneAdditional-sg")
  description = "Communication between the control plane and worker nodegroups"
  vpc_id      = data.aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    { Name = format("${var.env}-controllerplaneAdditional-sg") },
    var.additional_tags
  )
}
resource "aws_security_group_rule" "ClusterToNode" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.AdditionalSecurityGroup.id
  to_port                  = 65535
  type                     = "ingress"
}
resource "aws_security_group_rule" "internalcommunication" {
  description       = "Allow eks cluster access from openvpn to manage it"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.AdditionalSecurityGroup.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  type              = "ingress"
}
