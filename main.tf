provider "aws" {
  region = var.AWS_REGION
}

#Launching Openvpn Server
module "openvpn" {
  source          = "./module/openvpn"
  env             = var.env
  Project         = var.Project
  additional_tags = var.additional_tags
  appname         = "openvpn"
  role            = "vpn"
}
module "MongoDb" {
  source                    = "./module/MongoDb"
  amiid                     = "ami-08a916c921f01938c"
  env                       = var.env
  Project                   = var.Project
  additional_tags           = var.additional_tags
  appname                   = "MongoDb"
  role                      = "Database"
  openvpn_security_group_id = module.openvpn.OpenVpnSecurityGroup
  # depends_on = [
  #   module.openvpn
  # ]
}

module "SnR" {
  source                    = "./module/snr"
  amiid                     = "ami-08a916c921f01938c"
  env                       = var.env
  Project                   = var.Project
  additional_tags           = var.additional_tags
  appname                   = "SnR"
  role                      = "mqtt"
  openvpn_security_group_id = module.openvpn.OpenVpnSecurityGroup
  # depends_on = [
  #   module.openvpn
  # ]
}

module "gmqtt" {
  source                    = "./module/gmqtt/cluster-1"
  amiid                     = "ami-0caa21e75d5ed51f0"
  env                       = var.env
  Project                   = var.Project
  additional_tags           = var.additional_tags
  appname                   = "mqttbroker"
  role                      = "mqtt"
  openvpn_security_group_id = module.openvpn.OpenVpnSecurityGroup
  # depends_on = [
  #   module.openvpn
  # ]
}

