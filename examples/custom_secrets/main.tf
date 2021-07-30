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

  secret_path_format    = var.secret_path_format
  secrets_store_type    = var.secrets_store_type
  secrets_store_enabled = var.secrets_store_enabled

  asm_recovery_window_in_days = 0 // otherwise Terratest won't be able to force destroy ASM secrets

  context = module.this.context
}
