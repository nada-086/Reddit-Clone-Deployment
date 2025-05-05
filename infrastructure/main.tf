resource "tls_private_key" "ssh_private_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_public_key" {
    key_name = "ssh_public_key"
    public_key = tls_private_key.ssh_private_key.public_key_openssh
}

resource "local_file" "ssh_key" {
    filename = "private_key.pem"
    content = tls_private_key.ssh_private_key.private_key_pem
    file_permission = "0400"
}


resource "aws_security_group" "jenkins_sg" {
    name        = "jenkins_sg"
    description = "Allow traffic on ports 22, 80, 443, 8080, 9000, 3000 and all outbound traffic"

    tags = {
        Name = "Jenkins SG"
    }

    ingress = [
        for port in [22, 80, 443, 8080, 9000, 3000] : {
            description = "Allowing the Security Ports"
            from_port = port
            to_port = port
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self = false
        }
    ]

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "jenkins_sonarqube" {
    ami = "ami-0f88e80871fd81e91"
    instance_type = "t2.micro"
    key_name = "ssh_public_key"
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    tags = {
        Name = "Jenkins-SonarQube"
    }
}