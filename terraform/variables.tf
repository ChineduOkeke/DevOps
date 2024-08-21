variable "region" {
  default = "us-west-2"
}

variable "cluster_name" {
  default = "my-eks-cluster"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = ["subnet-0a12bc34de56f7890", "subnet-1b23cd45ef67g8901"]
}

variable "private_subnet_ids" {
  type    = list(string)
  default = ["subnet-0a12bc34de56f7890", "subnet-1b23cd45ef67g8901"]
}


