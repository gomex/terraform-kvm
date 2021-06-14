# TODO Add validation 

variable "domain_name" {
  type = string
  default = "ubuntu"
}

variable "ip_address" {
  type = string
  default = "192.168.0.2/24"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("/[0-9][0-9]$", var.ip_address))
    error_message = "The ip_address value must add the subnet mask (ex. 192.168.0.2/24)."
  }
}

variable "gateway4" {
  type = string
  default = "192.168.0.1"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.gateway4))
    error_message = "The gateway4 value must be ip address without subnet mask (ex. 192.168.0.1 )."
  }
}

variable "primary_nameserver" {
  type = string
  default = "1.1.1.1"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.primary_nameserver))
    error_message = "The primary_nameserver value must be ip address without subnet mask (ex. 192.168.0.1 )."
  }
}

variable "secondary_nameserver" {
  type = string
  default = "8.8.8.8"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.secondary_nameserver))
    error_message = "The secondary_nameserver value must be ip address without subnet mask (ex. 192.168.0.1 )."
  }
}

variable "memory" {
  type = string
  default = "512"
}

variable "cpu" {
  type = string
  default = 1
}

variable "kvm_host" {
  type = string
  default = "127.0.0.1"
}

variable "kvm_user" {
  type = string
}