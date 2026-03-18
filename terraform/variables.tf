variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.nano"
}

variable "ami_id" {
  description = "AMI ID for Amazon Linux 2"
  type        = string
  default     = "ami-02dfbd4ff395f2a1b"  # This is the AMI for Amazon Linux
}
