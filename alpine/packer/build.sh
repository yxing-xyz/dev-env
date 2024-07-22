#!/bin/sh
set -e
rm -rf ./output

download_alpine_iso() {
    alpine_version=$(curl -s https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/"$1"/ | \
    grep -oP '(?<=<a href=").*(?=")' | \
    grep '\.iso$' | grep standard | sort | tail -n 1)
    iso_url="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/$1/${alpine_version}"
    curl "$iso_url" -o alpine-$1.iso
}
download_alpine_iso $1
packer init  ./alpine.pkr.hcl

cpu_model=""
efi_boot="false"
mtp='pc'
efi_firmware_code=""
efi_firmware_vars=""
boot_wait="90s"
if [ "$1" = "aarch64" ]
then
    boot_wait="1h"
    cpu_model="max"
    mtp='virt'
    efi_boot="true"
    efi_firmware_code=eficode.fd
    efi_firmware_vars=efivars.fd
    dd if=/dev/zero of=$efi_firmware_code bs=1M count=64
    dd if=/dev/zero of=$efi_firmware_vars bs=1M count=64
    dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=$efi_firmware_code conv=notrunc
fi
PACKER_LOG=1 packer build -var "qemu_binary=qemu-system-$1" \
    -var "efi_boot=$efi_boot"  -var "efi_firmware_code=$efi_firmware_code" -var "efi_firmware_vars=$efi_firmware_vars" \
    -var "cpu_model=$cpu_model" -var "machine_type=$mtp" -var "iso_url=alpine-$1.iso" \
    -var "boot_wait=$boot_wait" \
    -var "vm_name=alpine-$1.qcow2" ./alpine.pkr.hcl
cp ./output/alpine-x86_64.qcow2 .
qemu-img convert -c -O qcow2 alpine-$1.qcow2 smaller.qcow2
mv -f smaller.qcow2 alpine-$1.qcow2