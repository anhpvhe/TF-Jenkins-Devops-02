variable "region" {
  description = "The AWS region to deploy the infrastructure in"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "Public subnet AZ1 CIDR block"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "Public subnet AZ2 CIDR block"
  type        = string
}

variable "private_subnet_az1_cidr" {
  description = "Private subnet AZ1 CIDR block"
  type        = string
}

variable "private_subnet_az2_cidr" {
  description = "Private subnet AZ2 CIDR block"
  type        = string
}

variable "private_data_subnet_az1_cidr" {
  description = "Private data subnet AZ1 CIDR block"
  type        = string
}

variable "private_data_subnet_az2_cidr" {
  description = "Private data subnet AZ2 CIDR block"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
