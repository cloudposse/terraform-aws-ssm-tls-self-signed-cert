region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert-cmk"

secret_path_format = "/test-cmk/%s.%s"

certificate_backends = ["SSM"]

create_cmk = true
