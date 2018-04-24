variable "cluster_name" {
  type = "string"
}

variable "trusted_cidr_range" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "aws_key_name" {
  type = "string"
}

variable "master_count" {
  type = "string"
}

variable "master_instance_type" {
  type    = "string"
  default = "t2.large"
}

variable "master_root_volume_type" {
  type    = "string"
  default = "gp2"
}

variable "master_root_volume_size" {
  type    = "string"
  default = "100"
}

variable "master_root_volume_iops" {
  type    = "string"
  default = "100"
}

variable "node_count" {
  type = "string"
}

variable "node_instance_type" {
  type    = "string"
  default = "t2.large"
}

variable "node_root_volume_type" {
  type    = "string"
  default = "gp2"
}

variable "node_root_volume_size" {
  type    = "string"
  default = "100"
}

variable "node_root_volume_iops" {
  type    = "string"
  default = "100"
}
