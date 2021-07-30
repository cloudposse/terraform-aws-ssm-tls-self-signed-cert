provider "aws" {
  region = var.region
}

module "self_signed_cert" {
  source = "../.."

  subject = {
    common_name         = module.this.id
    organization        = "Cloud Posse"
    organizational_unit = "Engineering"
  }

  validity = {
    duration_hours      = 730
    early_renewal_hours = 24
  }

  allowed_uses = var.is_ca ? [
    "crl_signing",
    "digital_signature",
    "digital_signature"
    ] : [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  subject_alt_names = var.is_ca ? {
    ip_addresses = null
    dns_names    = null
    uris         = null
    } : {
    ip_addresses = ["10.10.10.10"]
    dns_names    = ["example.com"]
    uris         = ["https://example.com"]
  }

  basic_constraints = {
    ca = var.is_ca
  }

  skid_enabled = true

  context = module.this.context
}
