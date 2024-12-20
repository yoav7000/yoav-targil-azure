variable "entry_vm_username" {
  description = "The username for the Windows VM"
  type        = string
}

variable "entry_vm_password" {
  description = "The password for the Windows VM"
  type        = string
  sensitive   = true
}

variable "spoke_vm_username" {
  description = "The username for the Linux spoke VM"
  type        = string
}

variable "spoke_vm_password" {
  description = "The password for the Linux spoke VM"
  type        = string
  sensitive   = true
}