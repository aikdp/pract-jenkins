output "jenkins_master" {
  value       = aws_instance.jenkins_server.public_ip
}

output "jenkins_agent" {
  value       = aws_instance.jenkins_agent.public_ip
}
