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
    Owner   = ""
    project = ""
  }
}

variable "vpccidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = ""
}

variable "pubsub1cidr" {
  type        = string
  description = "CIDR block for the publicsubnet 1"
  default     = ""
}

variable "pubsub2cidr" {
  type        = string
  description = "CIDR block for the publicsubnet 2"
  default     = ""
}

variable "pubsub3cidr" {
  type        = string
  description = "CIDR block for the publicsubnet 3"
  default     = ""
}

variable "prisub1cidr" {
  type        = string
  description = "CIDR block for the privatesubnet 1"
  default     = ""
}

variable "prisub2cidr" {
  type        = string
  description = "CIDR block for the privatesubnet 1"
  default     = ""
}

variable "prisub3cidr" {
  type        = string
  description = "CIDR block for the privatesubnet 1"
  default     = ""
}


