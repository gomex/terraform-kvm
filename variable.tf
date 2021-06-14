# TODO Add validation 

variable "domain_name" {
  type = string
  default = "ubuntu"
}

variable "ip_address" {
  type = string
  default = "10.136.0.4/16"
}

variable "gateway4" {
  type = string
  default = "10.136.0.1"
}

variable "primary_nameserver" {
  type = string
  default = "1.1.1.1"
}

variable "secondary_nameserver" {
  type = string
  default = "8.8.8.8"
}

variable "memory" {
  type = string
  default = "512"
}

variable "cpu" {
  type = string
  default = 1
}