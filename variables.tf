variable "prefix" {

}
variable "location" {

}

variable "envs" {
  type        = list(string)
  description = "Environments"

}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"

}
variable "mangement_subnet_cidr" {
  type        = list(string)
  description = "Public subnet CIDE of mangement"
}

variable "ssh_public_key" {
  type        = string
  description = "Path to your SSH public key"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}


#managemnt vars
variable "env_mangement" {
  type = string

}

variable "pipelne_vm_count" {
  type = number
}

#postgress secrets
# will be stores as env vars in local shell using:
# export TF_VAR_username=<value>
variable "username" {
  type = string
}
variable "password" {
  type = string
}


variable "sku" {
  type = list(string)
}
