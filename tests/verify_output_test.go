package tests

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestBucketAndTableExist(t *testing.T) {
    expectedBucketName        := "bb-test-tfbackend-rand212"
    expectedDynamoDbTableName := "bb-test-tfbackend-rand212"

    terraformOptions := &terraform.Options {
        // The path to where our Terraform code is located
        TerraformDir: "../examples/s3-tfstate-backend",

        // Override variables
        Vars: map[string]interface{} {
            "name": "tfbackend-rand212",
        },

        // Disable colors in Terraform commands so its easier to parse stdout/stderr
        NoColor: true,
    }

    // At the end of the test, run `terraform destroy` to clean up any resources that were created
    defer terraform.Destroy(t, terraformOptions)

    // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
    terraform.InitAndApply(t, terraformOptions)

    // Run `terraform output` to get the values of output variables
    actualBucketName        := terraform.Output(t, terraformOptions, "s3_bucket_id")
    actualDynamoDbTableName := terraform.Output(t, terraformOptions, "dynamodb_table_name")

    // Verify we're getting back the outputs we expect
    assert.Equal(t, expectedBucketName, actualBucketName)
    assert.Equal(t, expectedDynamoDbTableName, actualDynamoDbTableName)
}

func TestReplicatedBucketAndTableExist(t *testing.T) {
    expectedBucketName        := "bb-test-tfbackend-crr-rand980"
    expectedDynamoDbTableName := "bb-test-tfbackend-crr-rand980"

    terraformOptions := &terraform.Options {
        // The path to where our Terraform code is located
        TerraformDir: "../examples/s3-tfstate-backend-crr",

        // Override variables
        Vars: map[string]interface{} {
            "name": "tfbackend-crr-rand980",
        },

        // Disable colors in Terraform commands so its easier to parse stdout/stderr
        NoColor: true,
    }

    // At the end of the test, run `terraform destroy` to clean up any resources that were created
    defer terraform.Destroy(t, terraformOptions)

    // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
    terraform.InitAndApply(t, terraformOptions)

    // Run `terraform output` to get the values of output variables
    actualBucketName        := terraform.Output(t, terraformOptions, "s3_bucket_id")
    actualDynamoDbTableName := terraform.Output(t, terraformOptions, "dynamodb_table_name")

    // Verify we're getting back the outputs we expect
    assert.Equal(t, expectedBucketName, actualBucketName)
    assert.Equal(t, expectedDynamoDbTableName, actualDynamoDbTableName)
}

// func TestReplicatedBucketAndTableExistVpceEnforced(t *testing.T) {
//     expectedBucketName        := "bb-test-terraform-crr-vpce"
//     expectedDynamoDbTableName := "bb-test-terraform-crr-vpce"
//
//     terraformOptions := &terraform.Options {
//         // The path to where our Terraform code is located
//         TerraformDir: "../examples/s3-tfstate-backend-crr-vpce",
//
//         // Disable colors in Terraform commands so its easier to parse stdout/stderr
//         NoColor: true,
//     }
//
//     // At the end of the test, run `terraform destroy` to clean up any resources that were created
//     defer terraform.Destroy(t, terraformOptions)
//
//     // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
//     terraform.InitAndApply(t, terraformOptions)
//
//     // Run `terraform output` to get the values of output variables
//     actualBucketName        := terraform.Output(t, terraformOptions, "s3_bucket_id")
//     actualDynamoDbTableName := terraform.Output(t, terraformOptions, "dynamodb_table_name")
//
//     // Verify we're getting back the outputs we expect
//     assert.Equal(t, expectedBucketName, actualBucketName)
//     assert.Equal(t, expectedDynamoDbTableName, actualDynamoDbTableName)
// }

// func TestReplicatedBucketAndTableExistSslEnforced(t *testing.T) {
//     expectedBucketName        := "bb-test-terraform-crr-ssl"
//     expectedDynamoDbTableName := "bb-test-terraform-crr-ssl"
//
//     terraformOptions := &terraform.Options {
//         // The path to where our Terraform code is located
//         TerraformDir: "../examples/s3-tfstate-backend-crr-ssl",
//
//         // Disable colors in Terraform commands so its easier to parse stdout/stderr
//         NoColor: true,
//     }
//
//     // At the end of the test, run `terraform destroy` to clean up any resources that were created
//     defer terraform.Destroy(t, terraformOptions)
//
//     // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
//     terraform.InitAndApply(t, terraformOptions)
//
//     // Run `terraform output` to get the values of output variables
//     actualBucketName        := terraform.Output(t, terraformOptions, "s3_bucket_id")
//     actualDynamoDbTableName := terraform.Output(t, terraformOptions, "dynamodb_table_name")
//
//     // Verify we're getting back the outputs we expect
//     assert.Equal(t, expectedBucketName, actualBucketName)
//     assert.Equal(t, expectedDynamoDbTableName, actualDynamoDbTableName)
// }
