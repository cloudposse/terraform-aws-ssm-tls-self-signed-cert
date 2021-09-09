resource "aws_acm_certificate" "root" {
  count             = local.acm_enabled ? 1 : 0
  private_key       = join("", tls_private_key.default.*.private_key_pem)
  certificate_body  = join("", tls_private_key.default.*.private_key_pem)
  certificate_chain = var.basic_constraints.ca ? var.certificate_chain : null
}
