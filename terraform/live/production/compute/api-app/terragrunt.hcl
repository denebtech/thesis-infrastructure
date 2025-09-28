terraform {
  source = "../../../../shared/compute/droplet"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

inputs = {
  droplet = {
    name     = "thsis-api-app"
    image    = "almalinux-9-x64"
    region   = "nyc3"
    size     = "s-1vcpu-1gb"
    backups  = false
    ssh_keys = ["51037160"]
  }
  project_name = "Thesis"
  firewall = {
    name = "thesis-api-app-22-80-and-443"
    inbound_rules = [
      {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["181.111.80.58/32"]
      },
      {
        protocol         = "tcp"
        port_range       = "80"
        source_addresses = ["0.0.0.0/0"]
      },
      {
        protocol         = "tcp"
        port_range       = "443"
        source_addresses = ["0.0.0.0/0"]
      }
    ]
    outbound_rules = [
      {
        protocol              = "tcp"
        port_range            = "all"
        destination_addresses = ["0.0.0.0/0"]
      },
      {
        protocol              = "udp"
        port_range            = "all"
        destination_addresses = ["0.0.0.0/0"]
      }
    ]
  }
}
