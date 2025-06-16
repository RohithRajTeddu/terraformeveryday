variable "ami_id" {
  type        = string
  description = "The ID of the AMI to use for the instance"
  default     = ""
}

variable "instance_type" {
  type = string
  description = "Type of the instance"
  default = "t2.micro"
}

variable "instance_count" {
  type = number
  description = "The number of instances to launch"
  default = 2
}
