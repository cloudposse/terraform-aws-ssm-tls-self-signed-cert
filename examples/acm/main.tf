provider "aws" {
  region = var.region
}

module "self_signed_cert_ca" {
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

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ] 

  subject_alt_names = {
    ip_addresses = null
    dns_names    = null
    uris         = null
  }

  basic_constraints = var.basic_constraints

  context = module.this.context
}

module "self_signed_cert_server" {
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

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  subject_alt_names = {
    ip_addresses = ["10.10.10.10"]
    dns_names    = ["example.com"]
    uris         = ["https://example.com"]
  }

  basic_constraints = var.basic_constraints

  certificate_chain = module.self_signed_cert_ca.certificate_pem

  context = module.this.context
}
