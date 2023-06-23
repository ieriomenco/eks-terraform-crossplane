locals {
    cluster_name = "${ var.project }-eks"
}

variable "project" {
  default = "crossplane"
}

variable "region" {
  default = "eu-west-1"
}

variable "profile" {
    description = "AWS credentials profile you want to use"
}