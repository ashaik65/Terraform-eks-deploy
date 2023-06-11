terraform {
  backend "s3" {
    bucket = "anis-terraform-backend1"
    key    = "ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}