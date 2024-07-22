packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "qemu_binary" {
  type        = string
  description = ""
}
variable "machine_type" {
  type        = string
  description = ""
}
variable "iso_url" {
  type        = string
  description = ""
}
variable "vm_name" {
  type        = string
  description = ""
}

variable "efi_boot" {
  type        = bool
  default = false
  description = ""
}
variable efi_firmware_code {
  type        = string
  default = ""
  description = ""
}

variable cpu_model {
  type        = string
  default = ""
  description = ""
}

variable boot_wait {
  type        = string
  default = ""
  description = ""
}
variable efi_firmware_vars {
  type        = string
  default = ""
  description = ""
}
source "qemu" "example" {
  cpus              = 2
  memory            = 4096
  iso_checksum      = "none"
  disk_size         = "20G"
  format            = "qcow2"
  accelerator       = "tcg"
  http_directory    = "."
  ssh_username      = "root"
  ssh_password      = "root"
  ssh_timeout       = "3h"
  net_device        = "virtio-net"
  disk_interface    = "virtio"
  headless          = true
  boot_command      = [
    "root<enter><wait>",
    "ip link set eth0 up && udhcpc -i eth0 &&<enter>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/boot.sh &&<enter>",
    "chmod +x boot.sh && ./boot.sh<enter> && rm ./boot.sh<enter>"
  ]
  qemuargs = [
    ["-device", "qemu-xhci"],
    ["-device", "usb-kbd"],
    ["-device", "usb-tablet"],
    ["-device", "virtio-gpu"],
  ]
  shutdown_command  = "poweroff"
  qemu_binary       = var.qemu_binary
  machine_type      = var.machine_type
  iso_url           = var.iso_url
  vm_name           = var.vm_name
  output_directory  = "./output"
  efi_boot          = var.efi_boot
  efi_firmware_code = var.efi_firmware_code
  efi_firmware_vars = var.efi_firmware_vars
  cpu_model         = var.cpu_model
  boot_wait         = var.boot_wait
}

build {
  sources = ["source.qemu.example"]
  provisioner "shell" {
    script       = "install.sh"
    timeout      = "1h10m1s"
  }
}
