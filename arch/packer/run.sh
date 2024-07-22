#!/bin/sh
set -e
rm -rf ./output

download_iso() {
    iso_url="https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso"
    curl "$iso_url" -o arch.iso
}
download_iso
packer init  ./arch.pkr.hcl

cpu_model=""
efi_boot="false"
mtp='pc'
efi_firmware_code=""
efi_firmware_vars=""
boot_wait="120s"
qemu_binary='qemu-system-x86_64'
iso_url='arch.iso'
vm_name='arch.qcow2'
PACKER_LOG=1 packer build -var "qemu_binary=$qemu_binary" \
    -var "efi_boot=$efi_boot"  -var "efi_firmware_code=$efi_firmware_code" -var "efi_firmware_vars=$efi_firmware_vars" \
    -var "cpu_model=$cpu_model" -var "machine_type=$mtp" -var "iso_url=$iso_url" \
    -var "boot_wait=$boot_wait" \
    -var "vm_name=$vm_name" ./arch.pkr.hcl

cp "./output/$vm_name" .
qemu-img convert -c -O qcow2 $vm_name smaller.qcow2
mv -f smaller.qcow2 $vm_name
