output "certificate_arn" {
  description = "ARN of certificate stored in ACM that other services may need to refer to. This is useful when the certificate is stored in ACM."
  value       = module.self_signed_cert_server.certificate_pem
}
