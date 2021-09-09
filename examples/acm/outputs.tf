output "certificate_key_path" {
  description = "Secrets store path containing the certificate private key file."
  value       = module.self_signed_cert_server.certificate_key_path
}

output "certificate_pem_path" {
  description = "Secrets store path containing the certificate PEM file."
  value       = module.self_signed_cert_server.certificate_pem_path
}

output "certificate_pem" {
  description = "Contents of the certificate PEM."
  value       = module.self_signed_cert_server.certificate_pem
}
