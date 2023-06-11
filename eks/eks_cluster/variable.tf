variable "AWS_REGION" {
  default = ""
}

variable "env" {
  type        = string
  description = "Set environment name"
  default     = ""
}
variable "Project" {
  type        = string
  description = "Project Name"
  default     = ""
}
variable "additional_tags" {
  type        = map(string)
  description = "Variable if additional tags is needed"
  default = {
    Environment = ""
    Owner       = ""
    project     = ""
  }
}



