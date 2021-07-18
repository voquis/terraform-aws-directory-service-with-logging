output "directory_service_directory" {
  value = aws_directory_service_directory.this
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.this
}

output "cloudwatch_log_resource_policy" {
  value = aws_cloudwatch_log_resource_policy.this
}

output "directory_service_log_subscription" {
  value = aws_directory_service_log_subscription.this
}
