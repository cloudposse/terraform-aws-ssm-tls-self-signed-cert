resource "aws_secretsmanager_secret" "pem" {
  count = local.asm_enabled ? 1 : 0

  name                    = format(var.secret_path_format, module.this.name, "pem")
  recovery_window_in_days = var.asm_recovery_window_in_days
  kms_key_id              = local.secrets_store_kms_key_id

  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "pem" {
  count = local.asm_enabled ? 1 : 0

  secret_id     = join("", aws_secretsmanager_secret.pem.*.name)
  secret_string = var.secrets_store_base64_enabled ? base64encode(local.tls_certificate) : local.tls_certificate
}

resource "aws_secretsmanager_secret" "private_key" {
  count = local.asm_enabled ? 1 : 0

  name                    = format(var.secret_path_format, module.this.name, "key")
  recovery_window_in_days = var.asm_recovery_window_in_days
  kms_key_id              = local.secrets_store_kms_key_id

  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "private_key" {
  count = local.asm_enabled ? 1 : 0

  secret_id     = join("", aws_secretsmanager_secret.private_key.*.name)
  secret_string = var.secrets_store_base64_enabled ? base64encode(local.tls_key) : local.tls_key
}
