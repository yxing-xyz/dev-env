#!/bin/sh
# 多端口转发
# -nic user,hostfwd=tcp::22-:22,hostfwd=::8080 \
nohup qemu-system-aarch64 \
    -machine virt \
    -accel hvf \
    -boot d \
    -cpu host \
    -smp 8 \
    -m 16384 \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-aarch64-code.fd \
    -drive if=pflash,format=raw,file=/opt/homebrew/Cellar/qemu/7.2.0/share/qemu/edk2-arm-vars.fd \
    -drive format=qcow2,file=/Users/x/workspace/demo/gentoo/linux.qcow2 \
    -device virtio-gpu \
    -device usb-ehci \
    -device usb-kbd \
    -device usb-mouse \
    -nic user,hostfwd=tcp::22-:22 \
    -display none > /dev/null &
