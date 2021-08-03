variable "region" {
  description = "The region to deploy AWS resources to."
  type        = string
}

variable "secret_path_format" {
  description = "The custom secret path to use."
  type        = string
}

variable "secrets_store_enabled" {
  description = "Whether or not to write to the secrets store."
  type        = bool
  default     = true
}

variable "secrets_store_type" {
  description = "The secrets store type to use, `SSM` or `ASM`."
  type        = string
  default     = "SSM"
}
