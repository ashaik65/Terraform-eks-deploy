data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-vpc"]
  }
}
data "aws_subnet" "pvt1" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Private-Subnet-a"]
  }
}
data "aws_subnet" "pvt2" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Private-Subnet-b"]
  }
}
data "aws_subnet" "pvt3" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Private-Subnet-c"]
  }
}
data "aws_subnet" "pub1" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Public-Subnet-a"]
  }
}
data "aws_subnet" "pub2" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Public-Subnet-b"]
  }
}
data "aws_subnet" "pub3" {
  filter {
    name   = "tag:Name"
    values = ["${var.Project}-${var.env}-Public-Subnet-c"]
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = format("${var.env}-cluster")
}