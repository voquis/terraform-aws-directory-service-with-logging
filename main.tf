# ---------------------------------------------------------------------------------------------------------------------
# Directory service, e.g. Microsoft Active Directory
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_directory_service_directory" "this" {
  name     = var.dns_name
  password = var.password == null ? random_password.this.result : var.password
  edition  = var.edition
  type     = var.type

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_ids
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Random password
# Provider Docs: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password
# ---------------------------------------------------------------------------------------------------------------------

resource "random_password" "this" {
  length           = var.password_length
  special          = var.password_special
  override_special = var.password_override_special
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloudwatch log group to deliver directory service logs
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/directoryservice/${aws_directory_service_directory.this.id}"
  retention_in_days = var.log_retention_in_days
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy document to allow directory to write to log group, that is later interpreted as JSON
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    principals {
      identifiers = ["ds.amazonaws.com"]
      type        = "Service"
    }

    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]

    effect = "Allow"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Cloudwatch log resource policy
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_resource_policy" "this" {
  policy_document = data.aws_iam_policy_document.this.json
  policy_name     = var.log_policy_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Subsription to push directory logs to cloudfront
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_log_subscription
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_directory_service_log_subscription" "this" {
  directory_id   = aws_directory_service_directory.this.id
  log_group_name = aws_cloudwatch_log_group.this.name
}
