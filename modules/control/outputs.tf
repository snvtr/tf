output "control_ip" {
  description = "control ip"
  value       = aws_instance.control.public_ip
}