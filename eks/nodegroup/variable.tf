variable "AWS_REGION" {
  default     = ""
  description = "AWS region"
}
variable "eks_cluster_name" {
  type        = string
  description = "(Required) The name of the Amazon EKS cluster."
  default     = ""
}

variable "security_group_ids" {
  type        = list(string)
  description = "(Optional) A list of security group IDs to associate with the worker nodes. The module automatically associates the EKS cluster securitygroup with the nodes."
  default     = []
}
variable "key_name" {
  type        = string
  description = "(Optional) The name of the EC2 key pair to configure on the nodes."
  default     = null
}

variable "env" {
  type        = string
  description = "Set environment name"
  default     = ""
}
variable "project" {
  type        = string
  default     = "ictsi"
  description = "Project Name"
}
variable "additional_tags" {
  type        = map(any)
  description = "Variable if additional tags is needed"
  default = {
  }
}

variable "desired_capacity" {
  type        = number
  description = "(Required) The desired number of nodes to create in the node group."
}
variable "min_size" {
  type        = number
  description = "(Required) The minimum number of nodes to create in the node group."
}
variable "max_size" {
  type        = number
  description = "(Required) The maximum number of nodes to create in the node group."
}

variable "ebs_volume_size" {
  type        = number
  description = "(Optional) The EBS volume size for a worker node. By default, the module uses the setting from the selected AMI."
  default     = null
}
variable "ebs_volume_type" {
  type        = string
  description = "(Optional) The EBS volume type for a worker node. By default, the module uses the setting from the selected AMI."
  default     = ""
}

variable "capacityType" {
  type        = string
  description = "ON_DEMAND or SPOT"
  default     = ""
}
variable "onDemandInstanceType" {
  type        = list(string)
  default     = []
  description = "(Required) The EC2 instance type to use for the worker nodes."
}
variable "spotInstanceType" {
  type        = list(string)
  default     = []
  description = "List of instance types for SPOT instance selection"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
}