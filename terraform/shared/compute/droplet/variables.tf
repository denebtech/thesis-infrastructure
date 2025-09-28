variable "droplet" {
  type = object({
    name    = string
    image   = string
    region  = string
    size    = string
    backups = optional(bool, false)
    backup_policy = optional(list(object({
      plan    = string
      weekday = number
      hour    = number
    })), null)
    ssh_keys = optional(list(string), [])
  })
}

variable "project_name" {
  type = string
}

variable "firewall" {
  type = object({
    name = string
    inbound_rules = list(object({
      protocol         = string
      port_range       = string
      source_addresses = list(string)
    }))
    outbound_rules = list(object({
      protocol              = string
      port_range            = string
      destination_addresses = list(string)
    }))
  })
}
