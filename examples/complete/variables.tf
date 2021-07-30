variable "region" {
  description = "The region to deploy AWS resources to."
  type        = string
}

variable "is_ca" {
  description = "Whether or not this certificate is a CA."
  type        = bool
  default     = false
}
