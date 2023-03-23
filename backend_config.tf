locals {
  backend_config_template_file = coalesce(var.backend_config_template_file, "${path.module}/templates/backend.tf.tpl")
}

data "aws_region" "current" {
  provider = aws.primary
}

resource "local_file" "backend_config" {
  count           = var.backend_config_filepath != "" ? 1 : 0
  filename        = "${var.backend_config_filepath}/${var.backend_config_filename}"
  file_permission = "0644"

  content = templatefile(local.backend_config_template_file, {
    region     = data.aws_region.current.name
    bucket     = aws_s3_bucket.default.id
    encrypt    = var.enable_server_side_encryption
    profile    = var.backend_config_profile
    role_arn   = var.backend_config_role_arn
    state_file = var.backend_config_state_file

    dynamodb_table = one(coalescelist(
      aws_dynamodb_table.with_server_side_encryption.*.id,
      aws_dynamodb_table.without_server_side_encryption.*.id,
    ))
  })
}
