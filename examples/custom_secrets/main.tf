provider "aws" {
  region = var.region
}

resource "aws_kms_key" "cmk" {
  count = var.create_cmk ? 1 : 0

  tags = module.this.tags
}

resource "aws_kms_alias" "cmk" {
  count = var.create_cmk ? 1 : 0

  target_key_id = join("", aws_kms_key.cmk.*.arn)

  name = format("alias/%s", module.this.id)
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

  secrets_store_kms_key_id = var.create_cmk ? join("", aws_kms_alias.cmk.*.name) : null

  context = module.this.context
}
