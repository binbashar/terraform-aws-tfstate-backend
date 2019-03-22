# Terraform Modules: Sample Module

## Overview
This module can be used as a reference for building other modules.


## Files Organization
* Terraform files are located at the root of this directory.
* Tests can be found under tests/ directory.


## Testing

### Key Points
* We use `terratest` for testing this module.
* Keep in mind that `terratest` is not a binary but a Go library with helpers that make it easier to work with Terraform and other tools.
* Test files use `_test` suffix. E.g.: `create_file_with_default_values_test.go`
* Test classes use `Test` prefix. E.g.: `func TestCreateFileWithDefaultValues(t *testing.T) {`
* Our tests make use of a fixture/ dir that resembles how the module will be used.

### Set Up
* Make sure this module is within the GOPATH directory.
    * Default GOPATH is usually set to $HOME/go but you can override that permanently or temporarily.
    * For instance, you could place all your modules under /home/john.doe/project_name/tf-modules/src/
    * Then you would use `export GOPATH=/home/john.doe/project_name/tf-modules/`
    * Or you could simply place all your modules under `$HOME/go/src/`
* Until AWS provider plugin is compatible with terraform 0.12, do:
    * Download plugin http://terraform-0.12.0-dev-snapshots.s3-website-us-west-2.amazonaws.com/terraform-provider-aws/ and unzip
    * mkdir -p fixture/.terraform/plugins/linux_amd64 
    * cp -p ~/<location>/terraform-provider-aws_v1.60.0-dev20190216H00-dev_x4  fixture/.terraform/plugins/linux_amd64/
* Go to the tests/ dir and run `dep ensure` to resolve all dependencies.
    * This should create a vendor/ dir under tests/ dir and also a pkg/ dir under the GOPATH dir.
* Now you can run `go test`
