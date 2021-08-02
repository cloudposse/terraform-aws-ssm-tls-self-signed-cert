variable "allowed_uses" {
  description = <<-EOT
  List of keywords each describing a use that is permitted for the issued certificate.
  Must be one of of the values outlined in [self_signed_cert.allowed_uses](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#allowed_uses).
  EOT
  type        = list(string)
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

variable "private_key_contents" {
  description = <<-EOT
  The contents of the private key to use for the certificate.
  If supplied, this module will not create a private key and use these contents instead for the private key.

  Defaults to `null`, which means a private key will be created.
  EOT
  type        = string
  default     = null
}

variable "private_key_algorithm" {
  description = <<-EOT
  The name of the algorithm for the private key of the certificate. Currently only RSA and ECDSA are supported.

  If a preexisting private key is supplied via `var.private_key_contents`, this value must match that key's algorithm.

  Defaults to RSA as it is a more widely adopted algorithm, although ECDSA provides the same level of security and with shorter keys.
  EOT
  type        = string
  default     = "RSA"
  validation {
    condition     = contains(["RSA", "ECDSA"], var.private_key_algorithm)
    error_message = "Algorithm must be one of: RSA, ECDSA."
  }
}

variable "private_key_rsa_bits" {
  description = <<-EOT
  When `var.cert_key_algorithm` is `RSA`, the size of the generated RSA key in bits.

  Ignored if `var.cert_key_algorithm` is not `RSA`, or if a preexisting private key is supplied via `var.private_key_contents`.

  Defaults to the `tls` provider default.
  EOT
  type        = number
  default     = 2048
}

variable "private_key_ecdsa_curve" {
  description = <<-EOT
  When `var.cert_key_algorithm` is `ECDSA`, the name of the elliptic curve to use. May be any one of `P224`, `P256`, `P384` or `P521`.

  Ignored if `var.cert_key_algorithm` is not `ECDSA`, or if a preexisting private key is supplied via `var.private_key_contents`.

  Defaults to the `tls` provider default.
  EOT
  type        = string
  default     = "P224"
}

variable "validity" {
  description = <<-EOT
  Validity settings for the issued certificate:

  `duration_hours`: The number of hours from issuing the certificate until it becomes invalid.
  `early_renewal_hours`: If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time (see: [self_signed_cert.early_renewal_hours](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#early_renewal_hours)).

  Defaults to 10 years and no early renewal hours.
  EOT
  type = object({
    duration_hours      = number
    early_renewal_hours = number
  })
  default = {
    duration_hours      = 87600
    early_renewal_hours = null
  }
}

variable "skid_enabled" {
  description = "Whether or not the subject key identifier (SKID) should be included in the certificate."
  type        = bool
  default     = false
}

variable "subject" {
  description = <<-EOT
  The subject configuration for the certificate.
  This should be a map that is compatible with [tls_cert_request.subject](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request#subject).

  If `common_name` is omitted, it will be set as `module.this.id`.
  EOT
  type        = any
  default     = {}
}

variable "subject_alt_names" {
  description = <<-EOT
  The subject alternative name (SAN) configuration for the certificate. This configuration consists of several lists, each of which can also be set to `null` or `[]`.

  `dns_names`: List of DNS names for which a certificate is being requested.
  `ip_addresses`: List of IP addresses for which a certificate is being requested.
  `uris`: List of URIs for which a certificate is being requested.

  Defaults to no SANs.
  EOT
  type = object({
    dns_names    = list(string)
    ip_addresses = list(string)
    uris         = list(string)
  })
  default = {
    dns_names    = null
    ip_addresses = null
    uris         = null
  }
}

// Secrets Store Variables

variable "asm_recovery_window_in_days" {
  description = <<-EOT
  Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be `0` to force deletion without recovery or range from `7` to `30` days.

  This value is ignored if `var.secrets_store_type` is not `ASM`, or if `var.secrets_store_enabled` is `false`.
  EOT
  type        = number
  default     = 30
}

variable "secret_path_format" {
  description = <<-EOT
  The path format to use when writing secrets to the secret store.

  The secret path will be computed as `format(var.secret_path_format, var.name, <secret extension>)`.
  Thus by default, if `var.name`=`example-self-signed-cert`, then the resulting secret path for the self-signed certificate's
  PEM file will be `/example-self-signed-cert.pem`.

  This variable can be overridden in order to create more specific secret store paths.
  EOT
  type        = string
  default     = "/%s.%s"

  validation {
    condition     = can(substr(var.secret_path_format, 0, 1) == "/")
    error_message = "The secret path format must contain a leading slash."
  }
}

variable "secrets_store_enabled" {
  description = "Enable or disable writing to the secrets store."
  type        = bool
  default     = true
}

variable "secrets_store_type" {
  description = <<-EOT
  The secret store type to use when writing secrets related to the self-signed certificate.
  The value specified can either be `SSM` (AWS Systems Manager Parameter Store) or `ASM` (AWS Secrets Manager).

  Defaults to `SSM`.
  EOT
  type        = string
  default     = "SSM"
  validation {
    condition     = contains(["SSM", "ASM"], var.secrets_store_type)
    error_message = "Secrets store type one be one of: SSM, ASM."
  }
}
