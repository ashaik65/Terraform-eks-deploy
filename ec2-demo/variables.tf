variable "AWS_REGION" {
  default = ""
}
variable "appname" {
  type        = string
  description = "Application Name"
  default     = ""
}
variable "env" {
  type        = string
  description = "Set environment name"
  default     = ""
}
variable "role" {
  type        = string
  description = "role of instance/service"
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
    Owner     = ""
    project   = ""
    role      = ""
    stoptime  = ""
    starttime = ""
    Schedule  = ""
    Backup    = ""
  }
}

variable "source_security_group_id" {
  default = ""
}
variable "hostedZone" {
  type    = string
  default = ""
}
variable "keyname" {
  type        = string
  description = "Key pair name to access ec2 machine"
  default     = ""
}
variable "domain_name" {
  type        = string
  description = "Set local host domain name"
  default     = ""
}
