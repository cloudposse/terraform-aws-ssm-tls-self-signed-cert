region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert-custom-suffixes"

secret_extensions = {
  certificate = "crt"
  private_key = "key"
}

secret_path_format = "/%s.%s"
