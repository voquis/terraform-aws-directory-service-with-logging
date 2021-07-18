# Required variables
variable "dns_name" {
  type        = string
  description = "Domain name of directory, e.g. example.com"
}

variable "vpc_id" {
  type        = string
  description = "VPC in which to create active directory domain controllers"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets in the VPC id in which to create domain controllers"
}

# Optional Variables
variable "password" {
  type        = string
  sensitive   = true
  description = "Directory password for Admin user, leave blank for random protected password"
  default     = null
}

variable "edition" {
  type        = string
  description = "Microsoft Active Directory edition: 'Standard' or 'Enterprise'"
  default     = "Standard"
}

variable "type" {
  type        = string
  description = "Directory type"
  default     = "MicrosoftAD"
}

# Password variables
variable "password_length" {
  type        = number
  description = "Random password string length"
  default     = 16
}

variable "password_special" {
  type        = bool
  description = "Whether to include special characters in random password"
  default     = true
}

variable "password_override_special" {
  type        = string
  description = "Random password special character overrides"
  default     = "_%@"
}

# Cloudwatch logging variables
variable "log_retention_in_days" {
  type        = number
  description = "The number of days to retain cloudwatch logs for Directory"
  default     = 30
}

variable "log_policy_name" {
  type        = string
  description = "IAM policy name for cloudwatch logging"
  default     = "ad-log-policy"
}
