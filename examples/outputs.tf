output "bucket_domain_name" {
  value       = module.s3.bucket_domain_name
  description = "FQDN of bucket"
}

output "bucket_id" {
  value       = module.s3.bucket_id
  description = "Bucket Name (aka ID)"
}

output "bucket_arn" {
  value       = module.s3.bucket_arn
  description = "Bucket ARN"
}

output "user_enabled" {
  value       = module.s3.user_enabled
  description = "Is user creation enabled"
}

output "user_name" {
  value       = module.s3.user_name
  description = "Normalized IAM user name"
}

output "user_arn" {
  value       = module.s3.user_arn
  description = "The ARN assigned by AWS for this user"
}

output "user_unique_id" {
  value       = module.s3.user_unique_id
  description = "The unique ID assigned by AWS"
}

output "access_key_id" {
  value       = module.s3.access_key_id
  description = "The access key ID"
}

output "secret_access_key" {
  sensitive   = true
  value       = module.s3.secret_access_key
  description = "The secret access key. This will be written to the state file in plain-text"
}

output "ses_smtp_password" {
  sensitive   = true
  value       = module.s3.ses_smtp_password
  description = "The secret access key converted into an SES SMTP password by applying AWS's documented conversion algorithm."
}