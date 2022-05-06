variable "namespace" {
  description = "vaule of the namespace "
  default     = "default"
  type        = string
}

variable "force_destroy_state" {
  description = "value of the force_destroy_state"
  default     = true
  type        = bool
}

variable "principal_arns" {
  description = "value of the pricipal_arns"
  default     = null
  type        = list(string)
}


