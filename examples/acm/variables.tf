variable "region" {
  description = "The region to deploy AWS resources to."
  type        = string
}

variable "basic_constraints" {
  description = <<-EOT
  The [basic constraints](https://datatracker.ietf.org/doc/html/rfc5280#section-4.2.1.9) of the issued certificate.
  Currently, only the `CA` constraint (which identifies whether the subject of the certificate is a CA) can be set.

  Defaults to this certificate not being a CA.
  EOT
  type = object({
    ca = bool
  })
  default = {
    ca = false
  }
}

variable "certificate_backends_enabled" {
  description = "Enable or disable writing to the secrets store."
  type        = bool
}

variable "certificate_backends" {
  description = <<-EOT
  The certificate backend to use when writing secrets related to the self-signed certificate.
  The value specified can either be `SSM` (AWS Systems Manager Parameter Store), `ASM` (AWS Secrets Manager), 
  and/or `ACM` (AWS Certificate Manager).

  Defaults to `SSM`.
  EOT
  type        = set(string)
}