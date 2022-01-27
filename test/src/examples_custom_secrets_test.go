package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesCustomSecrets(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
	}

	terraform.Init(t, terraformOptions)
	// Run tests in parallel
	t.Run("NoStore", testExamplesCustomSecretsNoStore)
	t.Run("SSM", testExamplesCustomSecretsSSM)
	t.Run("ASM", testExamplesCustomSecretsASM)
	t.Run("CMK", testExamplesCustomSecretsCMK)
	t.Run("CustomSuffixes", testExamplesCustomSecretsSuffixes)
}

func testExamplesCustomSecretsNoStore(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-no-store-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"no-store.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)
}

func testExamplesCustomSecretsSSM(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 1) // give a slightly different seed than the other parallel tests

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-ssm-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"ssm.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/test-ssm/eg-ue1-test-self-signed-cert-ssm"+attributes[0]+".pem", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/test-ssm/eg-ue1-test-self-signed-cert-ssm"+attributes[0]+".key", certificateKeyPath)
}

func testExamplesCustomSecretsASM(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 2) // give a slightly different seed than the other parallel tests

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-asm-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"asm.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/test-asm/eg-ue1-test-self-signed-cert-asm"+attributes[0]+".pem", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/test-asm/eg-ue1-test-self-signed-cert-asm"+attributes[0]+".key", certificateKeyPath)
}

func testExamplesCustomSecretsCMK(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 3) // give a slightly different seed than the other parallel tests

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-cmk-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"customer-managed-key.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/test-cmk/eg-ue1-test-self-signed-cert-cmk-"+attributes[0]+".pem", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/test-cmk/eg-ue1-test-self-signed-cert-cmk-"+attributes[0]+".key", certificateKeyPath)
}

func testExamplesCustomSecretsSuffixes(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 4) // give a slightly different seed than the other parallel tests

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/custom_secrets",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-custom-suffixes-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"custom-suffixes.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/eg-ue1-test-self-signed-cert-custom-suffixes"+attributes[0]+".crt", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/eg-ue1-test-self-signed-cert-custom-suffixes"+attributes[0]+".key", certificateKeyPath)
}
