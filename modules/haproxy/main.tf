resource "aws_key_pair" "haproxy_key" {
  key_name   = "haproxy-key"
  public_key = file("keys/id_rsa.pub")
}

resource "aws_instance" "haproxy" {

  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"

  key_name      = aws_key_pair.haproxy_key.key_name
  
  vpc_security_group_ids = [
    aws_security_group.haproxy_vpc.id
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.control.public_ip
  }

  tags = {
    Name = "haproxy-instance"
  }
}

resource "aws_security_group" "haproxy_vpc" {

  name        = "haproxy_vpc"

  # Open ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # http port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "haproxy-vpc"
  }
}


resource "local_file" "haproxy_address" {
  content  = aws_instance.haproxy.private_ip
  filename = "files/haproxy.txt"
}