resource "proxmox_vm_qemu" "proxmox_vm" {
  for_each = var.cloud_init_virtual_machines

  vmid = each.value.id
  name = each.value.vm_name
  tags = each.value.vm_tags

  target_node = each.value.target_node

  clone = each.value.vm_template

  os_type                 = "cloud-init"
  cloudinit_cdrom_storage = each.value.storage
  agent                   = 1

  hastate = each.value.vm_hastate
  hagroup = each.value.vm_hagroup

  startup = each.value.vm_startup
  onboot  = each.value.vm_onboot

  cpu     = "host"
  cores   = each.value.vm_cpu_cores
  sockets = each.value.vm_cpu_sockets
  memory  = each.value.vm_memory
  balloon = each.value.vm_balloon

  scsihw  = "virtio-scsi-single"
  hotplug = "disk,network,usb,memory,cpu"

  numa             = true
  automatic_reboot = true

  disks {
    scsi {
      scsi0 {
        disk {
          size      = each.value.vm_os_disk_size
          storage   = each.value.storage
          iothread  = true
          discard   = true
          replicate = true
        }
      }
      dynamic "scsi1" {
        for_each = each.value.vm_app_disk_size != null ? [1] : []
        content {
          disk {
            size     = each.value.vm_app_disk_size
            storage  = each.value.storage
            iothread = true
            discard  = true
          }
        }
      }
    }
  }

  network {
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "virtio"
    mtu       = 9000
    queues    = 0
    rate      = 0
    tag       = -1
  }

  ipconfig0 = "ip=${each.value.vm_ip_address},gw=${each.value.vm_gateway}"

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      qemu_os
    ]
  }
}
