package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesComplete(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
	}

	terraform.Init(t, terraformOptions)
	// Run tests in parallel
	t.Run("Disabled", testExamplesCompleteDisabled)
	t.Run("NonCA", testExamplesCompleteNonCA)
	t.Run("CA", testExamplesCompleteCA)
}

func testExamplesCompleteDisabled(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-disabled-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"enabled": false,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)
}

func testExamplesCompleteNonCA(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-non-ca-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/eg-ue1-test-self-signed-cert.pem", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/eg-ue1-test-self-signed-cert.key", certificateKeyPath)
}

func testExamplesCompleteCA(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 1) // give a slightly different seed than the other parallel test

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-ca-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"ca.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificatePEMPath := terraform.Output(t, terraformOptions, "certificate_pem_path")
	assert.Equal(t, "/self-signed-cert-ca.pem", certificatePEMPath)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	assert.Equal(t, "/self-signed-cert-ca.key", certificateKeyPath)
}
