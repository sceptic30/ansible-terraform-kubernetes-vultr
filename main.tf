terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.3.0"
    }

  }
}

provider "vultr" {
  api_key = file("${var.key_pairs["api_key"]}")
  # or export VULTR_API_KEY="Your Vultr API Key"
  rate_limit  = 700
  retry_limit = 3
}

resource "vultr_ssh_key" "ssh_public_key" {
  name    = "terraform-ssh-key"
  ssh_key = file("${var.key_pairs["public_key"]}")
}

resource "vultr_instance" "k8s-master" {
  plan                   = var.two_cpu_four_gb_ram
  region                 = var.vultr_amsterdam
  os_id                  = var.os_type
  label                  = "k8s-master server"
  hostname               = "k8s-master"
  enable_ipv6            = true
  backups                = "disabled"
  activation_email       = false
  ddos_protection        = false
  tag                    = "k8s-master server"
  ssh_key_ids            = ["${vultr_ssh_key.ssh_public_key.id}"]


  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("${var.key_pairs["private_key"]}")
      host        = self.main_ip
      #password = self.default_password
    }
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt autoremove -y",
      "sudo apt-get install -y whois wget git"
    ]
  }
}

resource "vultr_instance" "k8s-node" {
  plan                   = var.two_cpu_four_gb_ram
  region                 = var.vultr_amsterdam
  os_id                  = var.os_type
  label                  = "k8s-node0${(count.index + 1)}"
  hostname               = "k8s-node0${(count.index + 1)}"
  enable_ipv6            = true
  backups                = "disabled"
  activation_email       = false
  ddos_protection        = false
  tag                    = "k8s-node0${(count.index + 1)}"
  ssh_key_ids            = ["${vultr_ssh_key.ssh_public_key.id}"]
  count                  = var.node_number

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("${var.key_pairs["private_key"]}")
      host        = self.main_ip
      #password = self.default_password
    }
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt autoremove -y",
      "sudo apt-get install -y whois wget git"
    ]
  }
}

resource "vultr_dns_domain" "my_domain_name" {
  domain    = "admintutsdemo.live"
  ip = vultr_instance.k8s-master.main_ip
}

resource "vultr_dns_record" "a-record" {
  data   = vultr_instance.k8s-master.main_ip
  domain = vultr_dns_domain.my_domain_name.id
  name   = "www"
  type   = "A"
  ttl    = "300"
}

resource "vultr_dns_record" "jenkins-record" {
  data   = vultr_instance.k8s-master.main_ip
  domain = vultr_dns_domain.my_domain_name.id
  name   = "jenkins"
  type   = "A"
  ttl    = "300"
}

resource "vultr_dns_record" "grafana-record" {
  data   = vultr_instance.k8s-master.main_ip
  domain = vultr_dns_domain.my_domain_name.id
  name   = "grafana"
  type   = "A"
  ttl    = "300"
}
resource "vultr_dns_record" "prometheus-record" {
  data   = vultr_instance.k8s-master.main_ip
  domain = vultr_dns_domain.my_domain_name.id
  name   = "prometheus"
  type   = "A"
  ttl    = "300"
}

resource "vultr_dns_record" "alertmanager-record" {
  data   = vultr_instance.k8s-master.main_ip
  domain = vultr_dns_domain.my_domain_name.id
  name   = "alertmanager"
  type   = "A"
  ttl    = "300"
}
