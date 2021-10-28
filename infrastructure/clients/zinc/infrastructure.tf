variable "public_key" {
  type = string
}

variable "cloudflare_email" {
  type = string
}

variable "cloudflare_api_key" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}


variable "vultr_api_key" {
  type = string
}

provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}



# Create a DNS Record for the application instance deployed to Heroku
resource "cloudflare_record" "convene" {
  zone_id = var.cloudflare_zone_id
  name    = "convene"
  value   = "concave-cougar-3i77opu3gndyc7goxubexjnz.herokudns.com"
  type    = "CNAME"
  ttl    = 1
}

# Create a branded-domain for the Zinc Space
resource "cloudflare_record" "meet" {
  zone_id = var.cloudflare_zone_id
  name    = "meet"
  value   = "quiet-shark-e5n5v9yt13haqkprrhhjdidx.herokudns.com"
  type    = "CNAME"
  ttl    = 1
}

# Create a branded-domain for the Convene-demo space
resource "cloudflare_record" "convene-demo" {
  zone_id = var.cloudflare_zone_id
  name    = "convene-demo"
  value   = "immense-mouse-pxnyvs9k482ckrqx11jrzf6a.herokudns.com"
  type    = "CNAME"
  ttl    = 1
}

provider "vultr" {
  api_key = var.vultr_api_key
}

variable "vultr_snapshot_id" {
  type = string
}

resource "vultr_ssh_key" "my_ssh_key" {
  name    = "my-ssh-key"
  ssh_key = var.public_key
}

# Create a Vultr server for the videobridge
resource "vultr_server" "convene_vultr_video" {
  snapshot_id       = var.vultr_snapshot_id
  region_id         = "12"
  plan_id           = "402"
  label             = "convene-videobridge-zinc.zinc.coop"
  firewall_group_id = vultr_firewall_group.convene_vultr_firewall_group.id
  ssh_key_ids       = [vultr_ssh_key.my_ssh_key.id]
}

# Create a DNS record for the videobridge
resource "cloudflare_record" "convene-videobridge-zinc" {
  zone_id = var.cloudflare_zone_id
  name    = "convene-videobridge-zinc"
  value   = vultr_server.convene_vultr_video.main_ip
  type    = "A"
  ttl     = 1
}

# Create Vultr firewall group
resource "vultr_firewall_group" "convene_vultr_firewall_group" {
  description = "convene_vultr_firewall_group"
}

resource "vultr_firewall_rule" "allow_tls_convene_vultr_firewall_rule" {
  firewall_group_id = vultr_firewall_group.convene_vultr_firewall_group.id
  protocol          = "tcp"
  network           = "0.0.0.0/0"
  from_port         = "443"
}

resource "vultr_firewall_rule" "allow_ssh_convene_vultr_firewall_rule" {
  firewall_group_id = vultr_firewall_group.convene_vultr_firewall_group.id
  protocol          = "tcp"
  network           = "0.0.0.0/0"
  from_port         = "22"
}

resource "vultr_firewall_rule" "allow_http_convene_vultr_firewall_rule" {
  firewall_group_id = vultr_firewall_group.convene_vultr_firewall_group.id
  protocol          = "tcp"
  network           = "0.0.0.0/0"
  from_port         = "80"
}

resource "vultr_firewall_rule" "allow_jitsi_video_convene_vultr_firewall_rule" {
  firewall_group_id = vultr_firewall_group.convene_vultr_firewall_group.id
  protocol          = "udp"
  network           = "0.0.0.0/0"
  from_port         = "10000"
}
