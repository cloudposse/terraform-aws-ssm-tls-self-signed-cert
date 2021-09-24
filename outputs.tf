output "certificate_key_path" {
  description = "Secrets store path containing the certificate private key file."
  value       = local.asm_enabled || local.ssm_enabled ? coalesce(join("", aws_ssm_parameter.private_key.*.name), join("", aws_secretsmanager_secret.private_key.*.name)) : null
}

output "certificate_pem_path" {
  description = "Secrets store path containing the certificate PEM file."
  value       = local.asm_enabled || local.ssm_enabled ? coalesce(join("", aws_ssm_parameter.certificate.*.name), join("", aws_secretsmanager_secret.certificate.*.name)) : null
}

output "certificate_pem" {
  description = "Contents of the certificate PEM."
  value       = join("", tls_self_signed_cert.default.*.cert_pem)
}

output "certificate_arn" {
  description = "ARN of certificate stored in ACM that other services may need to refer to. This is useful when the certificate is stored in ACM."
  value       = join("", aws_acm_certificate.default.*.arn)
}

output "private_key_pem" {
  description = "Contents of private key pem. This value is sensitive. It requires enabling the `show_private_key` flag."
  value       = coalesce(join("", tls_private_key.default.*.private_key_pem), var.private_key_contents)
  senstive    = true
}