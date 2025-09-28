resource "digitalocean_droplet" "main" {
  name   = var.droplet.name
  image  = var.droplet.image
  region = var.droplet.region
  size   = var.droplet.size

  backups = var.droplet.backups

  dynamic "backup_policy" {
    for_each = var.droplet.backup_policy != null ? [var.droplet.backup_policy] : []

    content {
      plan    = backup_policy.value.plan
      weekday = backup_policy.value.weekday
      hour    = backup_policy.value.hour
    }
  }

  ssh_keys  = var.droplet.ssh_keys
  user_data = var.droplet.user_data
}

resource "digitalocean_firewall" "main" {
  name        = var.firewall.name
  droplet_ids = [digitalocean_droplet.main.id]

  dynamic "inbound_rule" {
    for_each = var.firewall.inbound_rules

    content {
      protocol         = inbound_rule.value.protocol
      port_range       = inbound_rule.value.port_range
      source_addresses = inbound_rule.value.source_addresses
    }
  }

  dynamic "outbound_rule" {
    for_each = var.firewall.outbound_rules

    content {
      protocol              = outbound_rule.value.protocol
      port_range            = outbound_rule.value.port_range
      destination_addresses = outbound_rule.value.destination_addresses
    }
  }
}

resource "digitalocean_project_resources" "main" {
  project = data.digitalocean_project.main.id
  resources = [
    digitalocean_droplet.main.urn
  ]
}
