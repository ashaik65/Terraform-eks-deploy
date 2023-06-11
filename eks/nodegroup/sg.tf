resource "aws_security_group" "this" {
  name        = format("${var.project}-${var.env}-nodegroup-sg")
  description = "Security Group for ${var.env} eks nodegroup"
  vpc_id      = data.aws_vpc.vpc.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    "Name"        = format("${var.project}-${var.env}-nodegroup-sg")
    "environment" = var.env
    "project"     = var.project
  }
  egress {
    description = "Allow egress port for outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }
}

resource "aws_security_group_rule" "ingress_rules" {
  count = length(var.ingress_rules)

  type              = "ingress"
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].cidr_block]
  description       = var.ingress_rules[count.index].description
  security_group_id = aws_security_group.this.id
}
