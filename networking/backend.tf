terraform {
  backend "s3" {
    bucket = "anis-terraform-backend1"
    key    = "networking/terraform.tfstate"
    region = "ap-south-1"
  }
}