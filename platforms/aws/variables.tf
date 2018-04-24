variable "cluster_name" {
  type = "string"
}

variable "trusted_cidr_range" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
