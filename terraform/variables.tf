################################
######     Variables      ######
################################

variable "resource_name" {
  type        = string
  description = "The name of the instance resource in AWS"
  default     = "stader-testnet-node-lightsail"
}

variable "resource_count" {
  type        = number
  description = "The amount of resources to deploy"
  default     = 2
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the instance to"
  default     = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "The AWS availability zone to deploy the instance to"
  default     = "us-east-1a"
}

variable "instance_type" {
  type        = string
  description = "The instance size"
  default     = "t3.2xlarge"
}

variable "keypair_name" {
  type        = string
  description = "The name of the keypair to use"
  default     = "stader-testnet-deployer-key"
}