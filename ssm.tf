resource "aws_ssm_parameter" "certificate" {
  count = local.ssm_enabled ? 1 : 0

  name   = format(var.secret_path_format, module.this.name, var.secret_extensions.certificate)
  type   = "SecureString"
  key_id = local.secrets_store_kms_key_id
  value  = var.secrets_store_base64_enabled ? base64encode(local.tls_certificate) : local.tls_certificate

  tags = module.this.tags
}

resource "aws_ssm_parameter" "private_key" {
  count = local.ssm_enabled ? 1 : 0

  name   = format(var.secret_path_format, module.this.name, var.secret_extensions.private_key)
  type   = "SecureString"
  key_id = local.secrets_store_kms_key_id
  value  = var.secrets_store_base64_enabled ? base64encode(local.tls_key) : local.tls_key

  tags = module.this.tags
}
