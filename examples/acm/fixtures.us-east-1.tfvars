region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert"

certificate_backends_enabled = true

certificate_backends = ["ACM"]

basic_constraints = {
  ca = true
}
