output "haproxy_ip" {
  description = "haproxy ip"
  value       = aws_instance.haproxy.public_ip
}