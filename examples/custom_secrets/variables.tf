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

variable "certificate_backends_enabled" {
  description = "Whether or not to write to the secrets store."
  type        = bool
  default     = true
}

variable "certificate_backends" {
  description = <<-EOT
  The certificate backend to use when writing secrets related to the self-signed certificate.
  The value specified can either be `SSM` (AWS Systems Manager Parameter Store), `ASM` (AWS Secrets Manager), 
  and/or `ACM` (AWS Certificate Manager).

  Defaults to `SSM`.
  EOT
  type        = list(string)
  default     = ["SSM"]
}
