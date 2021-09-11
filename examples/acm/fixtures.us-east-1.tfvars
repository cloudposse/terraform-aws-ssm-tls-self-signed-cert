region = "us-east-1"

namespace = "eg"

environment = "ue1"

stage = "test"

name = "self-signed-cert"

certificate_backends = [ "ACM" ]

ca_basic_constraints = {
  ca = true
}
