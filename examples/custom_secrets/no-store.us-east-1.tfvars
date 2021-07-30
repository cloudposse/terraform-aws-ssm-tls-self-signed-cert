region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert-ssm-disabled"

secret_path_format = "/ssm-test/%s.%s"

secrets_store_enabled = false

secrets_store_type = "SSM"
