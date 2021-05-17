variable "vultr_amsterdam" {
  description = "Vultr Amsterdam Region"
  default     = "ams"
}

variable "os_type" {
  description = "Ubuntu 20.04 x64"
  default     = 387
}

variable "two_cpu_four_gb_ram" {
  default = "vc2-2c-4gb"
  description = "4096 MB RAM,80 GB SSD,3.00 TB BW"
}

variable "one_cpu_two_gb_ram" {
  default = "vc2-1c-2gb"
  description = "2048 MB RAM,55 GB SSD,2.00 TB BW"
}

variable "node_number" {
  description = "Total machines number"
  default     = 1
}

variable "key_pairs" {
  type = map
  default = {
    public_key  = "keys/id_ed25519.pub",
    private_key = "keys/id_ed25519",
    api_key     = "keys/api-key"
  }
}
