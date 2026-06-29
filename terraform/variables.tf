variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "payment_app"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC to deploy the RDS instance into"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group ID of the application tier allowed to connect to RDS"
  type        = string
}
