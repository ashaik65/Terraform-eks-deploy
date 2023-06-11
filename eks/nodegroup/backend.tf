terraform {
  backend "s3" {
    bucket = "anis-terraform-backend1"
    key    = "eks/nodegroup/terraform.tfstate"
    region = "ap-south-1"
  }
}
