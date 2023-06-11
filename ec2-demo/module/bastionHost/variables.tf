variable "env" {
  type        = string
  description = "Set environment name"
  default     = ""
}
variable "appname" {
  type    = string
  default = "bastionHost"
}
variable "role" {
  type        = string
  description = "Role of application"
  default     = ""
}
variable "Project" {
  type        = string
  default     = ""
  description = "Project Name"
}
variable "additional_tags" {
  type        = map(string)
  description = "Variable if additional tags is needed"
  default = {
    environment = ""
    Owner       = ""
    project     = ""
    stoptime    = ""
    starttime   = ""
    Schedule    = ""
    Backup      = ""
  }
}
variable "amiid" {
  type        = string
  description = "AMI ID of instance"
  default     = ""
}
variable "itype" {
  type        = string
  description = "Instance type"
  default     = "t3a.micro"
}
variable "keyname" {
  type        = string
  description = "Key pair name to access ec2 machine"
  default     = ""
}

