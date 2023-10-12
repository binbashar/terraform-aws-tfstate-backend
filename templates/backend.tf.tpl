terraform {
  backend "s3" {
    region         = "${region}"
    bucket         = "${bucket}"
    key            = "${state_file}"
    %{~ if dynamodb_table != "" ~}
    dynamodb_table = "${dynamodb_table}"
    %{~ endif ~}
    profile        = "${profile}"
    encrypt        = "${encrypt}"
    %{~ if role_arn != "" ~}
    assume_role {
      role_arn = "${role_arn}"
    }
    %{~ endif ~}
  }
}
