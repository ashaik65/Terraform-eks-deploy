data "aws_vpc" "vpc" {
  filter {
    name   = "tag:environment"
    values = ["${var.env}"]
  }
}
data "aws_subnet" "pvt1" {
  filter {
    name   = "tag:environment"
    values = ["${var.env}"]
  }
  filter {
    name = "tag:Name"
    values = ["*-Private-Subnet-a"]
  }
}
data "aws_subnet" "pvt2" {
  filter {
    name   = "tag:environment"
    values = ["${var.env}"]
  }
    filter {
    name = "tag:Name"
    values = ["*-Private-Subnet-b"]
  }
}
data "aws_subnet" "pvt3" {
  filter {
    name   = "tag:environment"
    values = ["${var.env}"]
  }
    filter {
    name = "tag:Name"
    values = ["*-Private-Subnet-c"]
  }
}
data "aws_ssm_parameter" "WorkerNodeGroupRole" {
  name = "/iam/roles/WorkerNodeGroupRole"  
}

