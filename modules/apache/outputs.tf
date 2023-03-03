output "apache_ip" {
  description = "apache ip"
  value       = aws_instance.apache.private_ip
}
