output "instance_ip" {
    description = "EC2 Instance IP"
    value = aws_instance.jenkins_sonarqube.public_ip
}


output "public_key" {
    description = "SSH Public Key"
    value = aws_key_pair.ssh_public_key.public_key
    sensitive = true
}

output "private_key" {
    description = "SSH Private Key"
    value = tls_private_key.ssh_private_key.private_key_pem
    sensitive = true
}