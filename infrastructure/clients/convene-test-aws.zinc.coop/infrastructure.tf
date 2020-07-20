variable "cloudflare_email" {
  type = string
}


variable "cloudflare_api_key" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

# Create a record
resource "cloudflare_record" "convene-test-aws" {
  zone_id = var.cloudflare_zone_id
  name    = "convene-test-aws"
  value   = aws_eip.convene_ip.public_ip
  type    = "A"
  ttl     = 1
}

provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "convene_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["convene-jitsi-convene-test.zinc.coop*"]
  }
}

resource "aws_instance" "convene_video" {
  ami           = data.aws_ami.convene_ami.id
  instance_type = "t2.micro"
  tags = {
    Name = "convene-test-aws.zinc.coop"
  }
  security_groups = [aws_security_group.allow_ssh.name,
                     aws_security_group.allow_http.name,
                     aws_security_group.allow_tls.name,
                     aws_security_group.allow_jitsi_video.name]
  key_name = "deployer-key"
}

resource "aws_eip" "convene_ip" {
  instance = aws_instance.convene_video.id
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  ingress {
    description = "TLS from World"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_tls"
  }
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    description = "SSH from World"
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
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from World"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_ssh"
  }
}


resource "aws_security_group" "allow_jitsi_video" {
  name        = "allow_jitsi_video"
  description = "Allow jitsi video inbound traffic"

  ingress {
    description = "Jitsi Video from world"
    from_port   = 10000
    to_port     = 10000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_jitsi_video"
  }
}

variable "public_key" {
  type = string
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = var.public_key
}




