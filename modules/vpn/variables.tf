variable "aws_region" {}
variable "aws_profile" {}
variable "enabled" {
  type        = string
  description = "Set to `false` to prevent the module from creating any resources"
  default     = "true"
}

variable "client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation being /22 or greater, from which to assign client IP addresses"
  default = "18.0.0.0/22"
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the Client VPN endpoint."
}

variable "cert_dir" {
  default = "certs"
}

variable "domain" {
  default = "test.com"
}
variable "tags" {
  default = "test"
}

variable "active_directory" {
}

