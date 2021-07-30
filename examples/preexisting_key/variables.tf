variable "region" {
  description = "The region to deploy AWS resources to."
  type        = string
}

variable "private_key_contents" {
  description = "The contents of the private key to use when issuing the certificate."
  type        = string
}

variable "private_key_algorithm" {
  description = "The algorithm of the private key. Can be either RSA or ECDSA"
  type        = string
}
