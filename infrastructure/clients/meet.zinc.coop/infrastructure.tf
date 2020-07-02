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
resource "cloudflare_record" "meet" {
  zone_id = var.cloudflare_zone_id
  name    = "meet"
  value   = aws_eip.convene_ip.public_ip
  type    = "A"
  ttl     = 1
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "convene_video" {
  ami           = data.aws_ami.convene_ami.id
  instance_type = "t2.micro"
  tags = {
    Name = "meet.zinc.coop"
  }
  security_groups = [aws_security_group.allow_ssh.name,
                     aws_security_group.allow_http.name,
                     aws_security_group.allow_tls.name,
                     aws_security_group.allow_jitsi_video.name]
  key_name = "deployer-key"
}

data "aws_ami" "convene_ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["convene-jitsi-meet.zinc.coop*"]
  }
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

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDePOrtPv6qxawIMnsDi3mhND3uKKFZKxxq/HGAIU294u1jBEYCjQSHKD1ZuRMSTlXmg1NWPhFz4pAlIUT8t0zkOSz2NKSXlJ0Rl69AbE+6ye2CIL9nfqq9mgA2XHOKPnVIuXdpBuFMmOCavMe7oZKH+qJ7wVFZRKaoWdL1Sw+7wjfCAqMcjq3FW+PvNldFe3B1q9SowXQlXyJW7+wXUj6wBUj3D7kpKOBe7EiLCBytBaQ2ejCxtM8/pqttQqBwUnjF93Gazyw7Ax3JTy+PTIJmkziWKAssvNHsXtB3ijVZY/Do1wGI3MN2zEf3X2wn16Cm67sHQ8/3OR9V4cOQUlOMiEwaWNiHHC0wRi2aIkISVqyDSChu1PN0FgKWvA9MG8EHxSRbhsSHrZ9eVGVsUz92Ca/ZLn6BlhP7ZptgVi+TFmzutRlcwxPb04iO2tL9PA4HqxbjCll0oFCnHwZd7uBxCtQ60UYTH57HzKh0nxkKov0hTr+5bK39d7EEwIehbjIxgy5FCaVuO+HvllxEYtuPhjUHj7gQOOTP7B3SB4OHmGblqNJ+9+oU13DkbdL8Ln/OVf+SrZ462VX3FdqefWu639xFcHt/87K22c3Pd2VsPXSEVGMMyR5sfVPWdKTRlqe1E9sJo3vl70Vjjio/LvQXrwrmn2ozamLc82YuQyZoJw=="
}




