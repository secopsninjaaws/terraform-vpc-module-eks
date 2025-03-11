variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "Lucas-EKS-Module"

}

variable "tag_private_subnets" {
  description = "The tag for private subnets"
  type        = number
  default     = 1
}

variable "tag_public_subnets" {
  description = "The tag for public subnets"
  type        = number
  default     = 1
}
