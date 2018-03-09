provider "aws" {}

variable "public_ip" {
  # dig +short myip.opendns.com @resolver1.opendns.com
  default = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "friday_example" {
  name        = "friday_example"
  description = "Allow all inbound traffic from your IP address."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Adds SSH access"
  }
}

resource "aws_key_pair" "friday_example" {
  key_name   = "friday_example"
  public_key = "${file("ubuntu_ssh.pub")}"
}

resource "aws_instance" "friday_example" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = ["${aws_security_group.friday_example.id}"]
  key_name               = "friday_example"
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu_ssh")}"
    }

    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo apt-key fingerprint 0EBFCD88",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get -y update",
      "sudo apt-get -y install docker-ce docker-compose",
      # "sudo docker run hello-world",
      "echo 'Made with ♥ by picat'"
    ]
  }
}

output "instance_ips" {
  value = ["${aws_instance.friday_example.*.public_ip}"]
}
