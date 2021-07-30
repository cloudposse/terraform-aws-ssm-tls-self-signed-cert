resource "aws_secretsmanager_secret" "pem" {
  count = local.asm_enabled ? 1 : 0

  name                    = format(var.secret_path_format, module.this.name, "pem")
  recovery_window_in_days = var.asm_recovery_window_in_days

  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "pem" {
  count = local.asm_enabled ? 1 : 0

  secret_id     = join("", aws_secretsmanager_secret.pem.*.name)
  secret_string = join("", tls_self_signed_cert.default.*.cert_pem)
}

resource "aws_secretsmanager_secret" "private_key" {
  count = local.asm_enabled ? 1 : 0

  name                    = format(var.secret_path_format, module.this.name, "key")
  recovery_window_in_days = var.asm_recovery_window_in_days

  tags = module.this.tags
}

resource "aws_secretsmanager_secret_version" "private_key" {
  count = local.asm_enabled ? 1 : 0

  secret_id     = join("", aws_secretsmanager_secret.private_key.*.name)
  secret_string = coalesce(join("", tls_private_key.default.*.private_key_pem), var.private_key_contents)
}
