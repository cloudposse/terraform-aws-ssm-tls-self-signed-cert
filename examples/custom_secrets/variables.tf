variable "region" {
  description = "The region to deploy AWS resources to."
  type        = string
}

variable "create_cmk" {
  description = "Whether or not to create a CMK and use it for the secret."
  type        = bool
  default     = false
}

variable "secret_extensions" {
  description = "The extensions use when writing secrets to the secret store."
  type = object({
    certificate = string
    private_key = string
  })
  default = {
    certificate = "pem"
    private_key = "key"
  }
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
