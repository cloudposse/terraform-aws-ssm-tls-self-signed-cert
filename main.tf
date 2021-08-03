locals {
  enabled                  = module.this.enabled
  create_private_key       = local.enabled && try(length(var.private_key_contents), 0) == 0
  secrets_store_enabled    = local.enabled && var.secrets_store_enabled
  secrets_store_kms_key_id = try(length(var.secrets_store_kms_key_id), 0) > 0 ? var.secrets_store_kms_key_id : null
  ssm_enabled              = local.secrets_store_enabled && var.secrets_store_type == "SSM"
  asm_enabled              = local.secrets_store_enabled && var.secrets_store_type == "ASM"
}

resource "tls_private_key" "default" {
  count = local.create_private_key ? 1 : 0

  algorithm   = var.private_key_algorithm
  ecdsa_curve = var.private_key_algorithm == "ECDSA" ? var.private_key_ecdsa_curve : null
  rsa_bits    = var.private_key_algorithm == "RSA" ? var.private_key_rsa_bits : null
}

resource "tls_self_signed_cert" "default" {
  count = local.enabled ? 1 : 0

  is_ca_certificate = var.basic_constraints.ca

  key_algorithm   = var.private_key_algorithm
  private_key_pem = coalesce(join("", tls_private_key.default.*.private_key_pem), var.private_key_contents)

  validity_period_hours = var.validity.duration_hours
  early_renewal_hours   = var.validity.early_renewal_hours

  allowed_uses = var.allowed_uses

  subject {
    common_name         = lookup(var.subject, "common_name", module.this.id)
    organization        = lookup(var.subject, "organization", null)
    organizational_unit = lookup(var.subject, "organizational_unit", null)
    street_address      = lookup(var.subject, "street_address", null)
    locality            = lookup(var.subject, "locality", null)
    province            = lookup(var.subject, "province", null)
    country             = lookup(var.subject, "country", null)
    postal_code         = lookup(var.subject, "postal_code", null)
    serial_number       = lookup(var.subject, "serial_number", null)
  }

  dns_names    = var.subject_alt_names.dns_names
  ip_addresses = var.subject_alt_names.ip_addresses
  uris         = var.subject_alt_names.uris

  set_subject_key_id = var.skid_enabled
}
