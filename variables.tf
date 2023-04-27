variable "environment" {
  description = "AWS Environment"
  type        = string
}

variable "vpc_name" {
  description = "AWS VPC Name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "azs_region" {
  description = "Availability Zones in the Region"
  type        = list
}

variable "vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "public_subnets"{
  description = "Public Subnets"
  type        = list
}

variable "private_subnets"{
  description = "Private Subnets"
  type        = list
}

variable "eks_cluster_config" {
  description = "EKS main configuration"
  type = map
}
variable "eks_luminor_init_ng" {
  description = "EKS node groups default launching template"
  type = map
}


variable "ec2_instance_profile" {
  description = "EC2 Instance Profile ARN"
  type        = string
}

variable "ec2_key_pair" {
  description = "EC2 SSH key pair"
  type        = string
}

variable "ebs_csi_addon_version" {
  description = "EBS CSI Addon Verson"
  type        = string
}