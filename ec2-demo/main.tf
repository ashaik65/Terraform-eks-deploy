provider "aws" {
  region = var.AWS_REGION
}

#Launching bastionHost Server
module "bastionHost" {
  source          = "./module/bastionHost"
  env             = var.env
  Project         = var.Project
  additional_tags = var.additional_tags
  appname         = "bastionHost"
  role            = "bastionHost"
  amiid           = "ami-0caf778a172362f1c"
}
