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

  secret_extensions     = var.secret_extensions
  secret_path_format    = var.secret_path_format
  certificate_backends  = var.certificate_backends
  certificate_backends_enabled = var.certificate_backends_enabled

  asm_recovery_window_in_days = 0 // otherwise Terratest won't be able to force destroy ASM secrets

  certificate_backend_kms_key_id = var.create_cmk ? join("", aws_kms_alias.cmk.*.name) : null

  context = module.this.context
}
