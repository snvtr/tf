resource "aws_key_pair" "control_key" {
  key_name   = "control-key"
  public_key = file("keys/id_rsa.pub")
}


resource "aws_instance" "control" {

  ami           = "ami-09cd747c78a9add63"
  instance_type = "t2.micro"

  key_name      = aws_key_pair.control_key.key_name

  vpc_security_group_ids = [
    aws_security_group.control_vpc.id
  ]

  tags = {
    Name = "control-instance"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("keys/id_rsa")
    host        = aws_instance.control.public_ip
  }

  provisioner "file" {
    source      = "keys/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "ansible/"
    destination = "/tmp/"
  }

  provisioner "file" {
    content = templatefile("files/hosts.yaml.tpl", {APACHE_IP = var.apache_address, HAPROXY_IP = var.haproxy_address})
    destination = "/tmp/hosts.yaml"
  }

  provisioner "file" {
    content = templatefile("files/haproxy.cfg.tpl", {APACHE_IP = var.apache_address, HAPROXY_IP = var.haproxy_address})
    destination = "/tmp/haproxy.cfg"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0755 /tmp/do_all.sh",
      "/tmp/do_all.sh"
    ]
  }
}


resource "aws_security_group" "control_vpc" {

  name = "control_vpc"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "control-vpc"
  }
}


resource "local_file" "control_address" {
  content  = aws_instance.control.public_ip
  filename = "files/control.txt"
}
