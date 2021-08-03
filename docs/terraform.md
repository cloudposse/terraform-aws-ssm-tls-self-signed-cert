<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.pem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.pem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_ssm_parameter.pem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tls_private_key.default](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.default](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_allowed_uses"></a> [allowed\_uses](#input\_allowed\_uses) | List of keywords each describing a use that is permitted for the issued certificate.<br>Must be one of of the values outlined in [self\_signed\_cert.allowed\_uses](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#allowed_uses). | `list(string)` | n/a | yes |
| <a name="input_asm_recovery_window_in_days"></a> [asm\_recovery\_window\_in\_days](#input\_asm\_recovery\_window\_in\_days) | Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be `0` to force deletion without recovery or range from `7` to `30` days.<br><br>This value is ignored if `var.secrets_store_type` is not `ASM`, or if `var.secrets_store_enabled` is `false`. | `number` | `30` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_basic_constraints"></a> [basic\_constraints](#input\_basic\_constraints) | The [basic constraints](https://datatracker.ietf.org/doc/html/rfc5280#section-4.2.1.9) of the issued certificate.<br>Currently, only the `CA` constraint (which identifies whether the subject of the certificate is a CA) can be set.<br><br>Defaults to this certificate not being a CA. | <pre>object({<br>    ca = bool<br>  })</pre> | <pre>{<br>  "ca": false<br>}</pre> | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_private_key_algorithm"></a> [private\_key\_algorithm](#input\_private\_key\_algorithm) | The name of the algorithm for the private key of the certificate. Currently only RSA and ECDSA are supported.<br><br>If a preexisting private key is supplied via `var.private_key_contents`, this value must match that key's algorithm.<br><br>Defaults to RSA as it is a more widely adopted algorithm, although ECDSA provides the same level of security and with shorter keys. | `string` | `"RSA"` | no |
| <a name="input_private_key_contents"></a> [private\_key\_contents](#input\_private\_key\_contents) | The contents of the private key to use for the certificate.<br>If supplied, this module will not create a private key and use these contents instead for the private key.<br><br>Defaults to `null`, which means a private key will be created. | `string` | `null` | no |
| <a name="input_private_key_ecdsa_curve"></a> [private\_key\_ecdsa\_curve](#input\_private\_key\_ecdsa\_curve) | When `var.cert_key_algorithm` is `ECDSA`, the name of the elliptic curve to use. May be any one of `P224`, `P256`, `P384` or `P521`.<br><br>Ignored if `var.cert_key_algorithm` is not `ECDSA`, or if a preexisting private key is supplied via `var.private_key_contents`.<br><br>Defaults to the `tls` provider default. | `string` | `"P224"` | no |
| <a name="input_private_key_rsa_bits"></a> [private\_key\_rsa\_bits](#input\_private\_key\_rsa\_bits) | When `var.cert_key_algorithm` is `RSA`, the size of the generated RSA key in bits.<br><br>Ignored if `var.cert_key_algorithm` is not `RSA`, or if a preexisting private key is supplied via `var.private_key_contents`.<br><br>Defaults to the `tls` provider default. | `number` | `2048` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_secret_path_format"></a> [secret\_path\_format](#input\_secret\_path\_format) | The path format to use when writing secrets to the secret store.<br><br>The secret path will be computed as `format(var.secret_path_format, var.name, <secret extension>)`.<br>Thus by default, if `var.name`=`example-self-signed-cert`, then the resulting secret path for the self-signed certificate's<br>PEM file will be `/example-self-signed-cert.pem`.<br><br>This variable can be overridden in order to create more specific secret store paths. | `string` | `"/%s.%s"` | no |
| <a name="input_secrets_store_base64_enabled"></a> [secrets\_store\_base64\_enabled](#input\_secrets\_store\_base64\_enabled) | Enable or disable base64 encoding of secrets before writing them to the secrets store. | `bool` | `false` | no |
| <a name="input_secrets_store_enabled"></a> [secrets\_store\_enabled](#input\_secrets\_store\_enabled) | Enable or disable writing to the secrets store. | `bool` | `true` | no |
| <a name="input_secrets_store_kms_key_id"></a> [secrets\_store\_kms\_key\_id](#input\_secrets\_store\_kms\_key\_id) | The KMD Key ID (ARN or ID) to use when encrypting either the AWS SSM Parameters or AWS Secrets Manager Secrets relating to the certificate.<br><br>If not specified, the Amazon-managed Key `alias/aws/ssm` will be used if `var.secrets_store_type` is `SSM`,<br>and `alias/aws/secretsmanager` will be used if `var.secrets_store_type` is `ASM`. | `string` | `null` | no |
| <a name="input_secrets_store_type"></a> [secrets\_store\_type](#input\_secrets\_store\_type) | The secret store type to use when writing secrets related to the self-signed certificate.<br>The value specified can either be `SSM` (AWS Systems Manager Parameter Store) or `ASM` (AWS Secrets Manager).<br><br>Defaults to `SSM`. | `string` | `"SSM"` | no |
| <a name="input_skid_enabled"></a> [skid\_enabled](#input\_skid\_enabled) | Whether or not the subject key identifier (SKID) should be included in the certificate. | `bool` | `false` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subject"></a> [subject](#input\_subject) | The subject configuration for the certificate.<br>This should be a map that is compatible with [tls\_cert\_request.subject](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request#subject).<br><br>If `common_name` is omitted, it will be set as `module.this.id`. | `any` | `{}` | no |
| <a name="input_subject_alt_names"></a> [subject\_alt\_names](#input\_subject\_alt\_names) | The subject alternative name (SAN) configuration for the certificate. This configuration consists of several lists, each of which can also be set to `null` or `[]`.<br><br>`dns_names`: List of DNS names for which a certificate is being requested.<br>`ip_addresses`: List of IP addresses for which a certificate is being requested.<br>`uris`: List of URIs for which a certificate is being requested.<br><br>Defaults to no SANs. | <pre>object({<br>    dns_names    = list(string)<br>    ip_addresses = list(string)<br>    uris         = list(string)<br>  })</pre> | <pre>{<br>  "dns_names": null,<br>  "ip_addresses": null,<br>  "uris": null<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_validity"></a> [validity](#input\_validity) | Validity settings for the issued certificate:<br><br>`duration_hours`: The number of hours from issuing the certificate until it becomes invalid.<br>`early_renewal_hours`: If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time (see: [self\_signed\_cert.early\_renewal\_hours](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert#early_renewal_hours)).<br><br>Defaults to 10 years and no early renewal hours. | <pre>object({<br>    duration_hours      = number<br>    early_renewal_hours = number<br>  })</pre> | <pre>{<br>  "duration_hours": 87600,<br>  "early_renewal_hours": null<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_key_path"></a> [certificate\_key\_path](#output\_certificate\_key\_path) | Secrets store path containing the certificate private key file. |
| <a name="output_certificate_pem"></a> [certificate\_pem](#output\_certificate\_pem) | Contents of the certificate PEM. |
| <a name="output_certificate_pem_path"></a> [certificate\_pem\_path](#output\_certificate\_pem\_path) | Secrets store path containing the certificate PEM file. |
<!-- markdownlint-restore -->
