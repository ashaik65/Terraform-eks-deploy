
#tfsec:ignore:aws-ec2-enable-at-rest-encryption
resource "aws_instance" "ec2-instance" {
  ami                         = var.amiid
  instance_type               = "t3a.micro"
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  subnet_id                   = data.aws_subnet.pub1.id
  associate_public_ip_address = true
  key_name                    = var.keyname
  disable_api_termination     = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  vpc_security_group_ids = [
    aws_security_group.ec2-sg.id
  ]
  #tfsec:ignore:aws-ec2-enable-at-rest-encryption:exp:2022-08-30
  root_block_device {
    delete_on_termination = true
  }
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-${var.appname}", ) },
    { "environment" = "${var.env}" },
    { "appname" = var.appname },
    { "role" = var.role },
  var.additional_tags, )

  depends_on = [aws_security_group.ec2-sg]
}
resource "aws_eip" "openvpnEIp" {
  vpc = true
  tags = merge(
    { "Name" = format("${var.Project}-${var.env}-OpenvpnIP") },
  { "environment" = "${var.env}" })
}
resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.ec2-instance.id
  # public_ip   = aws_eip.openvpnEIp.address
  allocation_id = aws_eip.openvpnEIp.allocation_id
}