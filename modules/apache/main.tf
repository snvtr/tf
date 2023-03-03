resource "aws_key_pair" "apache_key" {
  key_name   = "apache-key"
  public_key = file("keys/id_rsa.pub")
}

resource "aws_instance" "apache" {
 
  ami           = "ami-09cd747c78a9add63" # Ubuntu 20.04
  instance_type = "t2.micro"

  key_name      = aws_key_pair.apache_key.key_name

  vpc_security_group_ids = [
    aws_security_group.apache_vpc.id
  ]
  
  #user_data = file("scripts/first-boot.sh")


  tags = {
    Name = "apache-instance"
  }
}

resource "aws_security_group" "apache_vpc" {

  name = "apache_vpc"

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

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.control.public_ip
  }

  tags = {
    Name = "apache-vpc"
  }
}


resource "local_file" "apache_address" {
  content  = aws_instance.apache.private_ip
  filename = "files/apache.txt"
}