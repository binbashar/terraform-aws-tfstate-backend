package tests

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBucketAndTableExist(t *testing.T) {
    expectedBucketName := "bb-test-terraform"
	expectedDynamoDbTableName := "bb-test-terraform"

	terraformOptions := &terraform.Options {
		// The path to where our Terraform code is located
		TerraformDir: "fixture/",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualBucketName := terraform.Output(t, terraformOptions, "s3_bucket_id")
	actualDynamoDbTableName := terraform.Output(t, terraformOptions, "dynamodb_table_name")

	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedBucketName, actualBucketName)
	assert.Equal(t, expectedDynamoDbTableName, actualDynamoDbTableName)
}