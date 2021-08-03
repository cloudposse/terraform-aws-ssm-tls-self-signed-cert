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
