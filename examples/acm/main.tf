provider "aws" {
  region = var.region
}

locals {
  enabled = module.this.enabled
}

module "self_signed_cert_ca" {
  source = "../.."

  name = "self-signed-cert-ca"

  subject = {
    common_name         = module.this.id
    organization        = "Cloud Posse"
    organizational_unit = "Engineering"
  }

  validity = {
    duration_hours      = 730
    early_renewal_hours = 24
  }

  basic_constraints = {
    ca = true
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ]

  certificate_backends_enabled = var.certificate_backends_enabled
  certificate_backends         = var.certificate_backends

  context = module.this.context
}

data "aws_ssm_parameter" "ca_key" {
  count = local.enabled ? 1 : 0

  name = module.self_signed_cert_ca.certificate_key_path

  depends_on = [
    module.self_signed_cert_ca
  ]
}

module "self_signed_cert_root" {
  source = "../.."

  name = "self-signed-cert-root"

  subject = {
    common_name         = module.this.id
    organization        = "Cloud Posse"
    organizational_unit = "Engineering"
  }

  basic_constraints = {
    ca = false
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]

  certificate_backends = var.certificate_backends

  use_locally_signed = true

  certificate_chain = {
    cert_pem        = module.self_signed_cert_ca.certificate_pem,
    private_key_pem = join("", data.aws_ssm_parameter.ca_key.*.value)
  }

  context = module.this.context
}

module "self_signed_cert_server" {
  source = "../.."

  name = "self-signed-cert-server"

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

  use_locally_signed = true

  certificate_chain = {
    cert_pem        = module.self_signed_cert_ca.certificate_pem,
    private_key_pem = join("", data.aws_ssm_parameter.ca_key.*.value)
  }

  certificate_backends_enabled = var.certificate_backends_enabled
  certificate_backends         = var.certificate_backends

  context = module.this.context
}
