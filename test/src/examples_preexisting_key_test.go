package test

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	cryptorand "crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ssm"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesPreexistingKey(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/preexisting_key",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
	}

	terraform.Init(t, terraformOptions)
	// Run tests in parallel
	t.Run("RSA", testExamplesPreexistingKeyRSA)
	t.Run("ECDSA", testExamplesPreexistingKeyECDSA)
}

func testExamplesPreexistingKeyRSA(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	privateKey, err := rsa.GenerateKey(cryptorand.Reader, 2048)
	if err != nil {
		t.Fatal("Cannot generate RSA key.")
	}
	privateKeyBytes := x509.MarshalPKCS1PrivateKey(privateKey)
	privateKeyPEM := pem.EncodeToMemory(
		&pem.Block{
			Type:  "RSA PRIVATE KEY",
			Bytes: privateKeyBytes,
		},
	)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/preexisting_key",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-rsa-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"name":                  "self-signed-cert-preexisting-rsa",
			"attributes":            attributes,
			"private_key_contents":  string(privateKeyPEM),
			"private_key_algorithm": "RSA",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	certificateKey, err := getSSMParameterValue("us-east-1", certificateKeyPath)
	if err != nil {
		t.Fatal(err)
	}
	assert.Equal(t, certificateKey, string(privateKeyPEM))
}

func testExamplesPreexistingKeyECDSA(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano() + 1) // give a slightly different seed than the other parallel test

	attributes := []string{strconv.Itoa(rand.Intn(100000))}

	privateKey, err := ecdsa.GenerateKey(elliptic.P224(), cryptorand.Reader)
	if err != nil {
		t.Fatal("Cannot generate ECDSA key.")
	}
	privateKeyBytes, err := x509.MarshalECPrivateKey(privateKey)
	if err != nil {
		t.Fatal("Cannot marshal ECDSA key.")
	}
	privateKeyPEM := pem.EncodeToMemory(
		&pem.Block{
			Type:  "EC PRIVATE KEY",
			Bytes: privateKeyBytes,
		},
	)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/preexisting_key",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-ecdsa-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-1.tfvars"},
		Vars: map[string]interface{}{
			"name":                  "self-signed-cert-preexisting-ecdsa",
			"attributes":            attributes,
			"private_key_contents":  string(privateKeyPEM),
			"private_key_algorithm": "ECDSA",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	certificateKeyPath := terraform.Output(t, terraformOptions, "certificate_key_path")
	certificateKey, err := getSSMParameterValue("us-east-1", certificateKeyPath)
	if err != nil {
		t.Fatal(err)
	}
	assert.Equal(t, certificateKey, string(privateKeyPEM))
}

func getSSMParameterValue(awsRegion string, parameterName string) (string, error) {
	awsSession, err := session.NewSessionWithOptions(session.Options{
		Config: aws.Config{Region: aws.String(awsRegion)},
	})
	if err != nil {
		return "", err
	}

	ssmSession := ssm.New(awsSession, aws.NewConfig().WithRegion(awsRegion))

	var withDecryption = true
	param, err := ssmSession.GetParameter(&ssm.GetParameterInput{
		Name:           &parameterName,
		WithDecryption: &withDecryption,
	})
	if err != nil {
		return "", err
	}
	return *param.Parameter.Value, nil
}
