output "rds_endpoint" {
  description = "Connection endpoint for the payment RDS instance"
  value       = aws_db_instance.payment_primary.endpoint
  sensitive   = true
}

output "rds_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.payment_primary.identifier
}

output "rds_security_group_id" {
  description = "Security group ID attached to RDS"
  value       = aws_security_group.rds.id
}
