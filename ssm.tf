resource "aws_ssm_parameter" "pem" {
  count = local.ssm_enabled ? 1 : 0

  name   = format(var.secret_path_format, module.this.name, "pem")
  type   = "SecureString"
  key_id = local.secrets_store_kms_key_id
  value  = join("", tls_self_signed_cert.default.*.cert_pem)

  tags = module.this.tags
}

resource "aws_ssm_parameter" "private_key" {
  count = local.ssm_enabled ? 1 : 0

  name   = format(var.secret_path_format, module.this.name, "key")
  type   = "SecureString"
  key_id = local.secrets_store_kms_key_id
  value  = coalesce(join("", tls_private_key.default.*.private_key_pem), var.private_key_contents)

  tags = module.this.tags
}
