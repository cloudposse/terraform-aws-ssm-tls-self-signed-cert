provider "aws" {
  region = var.region
}

module "self_signed_cert" {
  source = "../.."

  subject = {
    common_name = module.this.id
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]

  // These values will provided during Terratest runs
  private_key_contents  = var.private_key_contents
  private_key_algorithm = var.private_key_algorithm

  secrets_store_base64_enabled = var.secrets_store_base64_enabled

  context = module.this.context
}
