#!/bin/bash
# check-kvm.sh - validate /dev/kvm and permissions
set -e

echo "Checking /dev/kvm..."
if [ -e /dev/kvm ]; then
  ls -l /dev/kvm || true
  if id -nG "$USER" | grep -qw kvm; then
    echo "User $USER is in group kvm"
  else
    echo "Warning: user $USER is not in group kvm. To add: sudo usermod -aG kvm $USER && newgrp kvm"
  fi
else
  echo "/dev/kvm not found. On WSL2: enable Docker Desktop integration and expose /dev/kvm to the distro.\nOn native Linux: install KVM (libvirt/qemu) and ensure kernel modules (kvm, kvm_intel/kvm_amd) are loaded."
fi
