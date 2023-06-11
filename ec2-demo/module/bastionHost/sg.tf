resource "aws_security_group" "ec2-sg" {
  name        = format("${var.env}-${var.appname}-SG")
  description = "Security Group for ${var.appname} instance"
  vpc_id      = data.aws_vpc.vpc.id
  egress {
    description = "Allow egress port for outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sgr
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sshfromopenvpn" {
  description              = "Allow SSH access from openvpn server"
  from_port                = 22
  to_port                  = 22
  security_group_id = aws_security_group.ec2-sg.id
  protocol = "tcp"
  cidr_blocks =           ["0.0.0.0/0"]
  type                     = "ingress"
}


