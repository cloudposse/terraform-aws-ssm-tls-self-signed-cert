region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert-ssm"

secret_path_format = "/test-ssm/%s.%s"

certificate_backends = [ "SSM" ]
