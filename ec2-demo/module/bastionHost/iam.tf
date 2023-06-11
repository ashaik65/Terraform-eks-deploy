# Create Iam Role for ec2
resource "aws_iam_role" "ec2-role" {
  name               = format("${var.env}-${var.appname}-ec2-role", )
  path               = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "ec2-attach-1" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  ])
  name       = "${var.appname}-ec2-attachment"
  roles      = [aws_iam_role.ec2-role.name]
  policy_arn = each.value
}

# Create Ec2 Profile 
resource "aws_iam_instance_profile" "ec2_profile" {
  name = format("${var.env}-${var.appname}-ec2-profile", )
  role = aws_iam_role.ec2-role.name
}

