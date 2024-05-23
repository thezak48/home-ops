variable "pm_user" {
  description = "The username for the proxmox user"
  type        = string
  sensitive   = false
  default     = "terraform@pve"

}
variable "pm_password" {
  description = "The password for the proxmox user"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = true
}

variable "pm_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
  default     = "pve01.example.com"
}

variable "cloud_init_virtual_machines" {
  type = map(object({
    id               = number
    vm_name          = string
    vm_tags          = string
    target_node      = string
    vm_template      = string
    vm_hastate       = string
    vm_hagroup       = string
    vm_startup       = string
    vm_onboot        = bool
    vm_cpu_cores     = number
    vm_cpu_sockets   = number
    vm_memory        = string
    vm_balloon       = number
    vm_os_disk_size  = number
    vm_app_disk_size = number
    storage          = string
    vm_ip_address    = string
    vm_gateway       = string
  }))

  default = {

    "pihole01" = {
      id               = 100
      vm_name          = "pihole-p01"
      vm_template      = "ubuntu-jammy-cloudinit-template"
      onboot           = true
      vm_tags          = "dns;internal;pihole"
      target_node      = "pve01"
      vm_template      = "ubuntu-jammy-cloudinit-template"
      vm_hastate       = "started"
      vm_hagroup       = "Top-Down"
      vm_startup       = "order=1"
      vm_onboot        = true
      vm_cpu_cores     = 2
      vm_cpu_sockets   = 1
      vm_memory        = "2048"
      vm_balloon       = 0
      vm_os_disk_size  = 10
      vm_app_disk_size = null
      storage          = "SSD"
      vm_ip_address    = "10.0.2.254/22"
      vm_gateway       = "10.0.0.1"
    }

    "docker01" = {
      id               = 101
      vm_name          = "docker-p01"
      vm_template      = "ubuntu-jammy-cloudinit-template"
      onboot           = true
      vm_tags          = "docker;internal"
      target_node      = "pve01"
      vm_template      = "ubuntu-jammy-cloudinit-template"
      vm_hastate       = "started"
      vm_hagroup       = ""
      vm_startup       = ""
      vm_onboot        = true
      vm_cpu_cores     = 16
      vm_cpu_sockets   = 1
      vm_memory        = "32768"
      vm_balloon       = 8192
      vm_os_disk_size  = 40
      vm_app_disk_size = 100
      storage          = "Ceph"
      vm_ip_address    = "10.0.2.10/22"
      vm_gateway       = "10.0.0.1"
    }
  }
}
