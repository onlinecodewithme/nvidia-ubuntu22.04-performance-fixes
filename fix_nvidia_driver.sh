#!/bin/bash
# Fix NVIDIA Driver Version Mismatch
# This script resolves the driver/library mismatch causing system slowness

echo "=========================================="
echo "NVIDIA Driver Mismatch Fix Script"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "ERROR: This script must be run with sudo privileges"
    echo "Usage: sudo bash fix_nvidia_driver.sh"
    exit 1
fi

echo "[1/5] Creating backup of current driver list..."
dpkg -l | grep nvidia > ~/nvidia_packages_backup_$(date +%Y%m%d_%H%M%S).txt
echo "✓ Backup saved to home directory"
echo ""

echo "[2/5] Removing old and conflicting NVIDIA packages..."
apt-get remove --purge -y \
    libnvidia-cfg1-570 \
    libnvidia-compute-570 \
    libnvidia-decode-570 \
    'nvidia-*-550' \
    'libnvidia-*-550' \
    'linux-modules-nvidia-550*' \
    'linux-objects-nvidia-550*'

echo "✓ Old packages removed"
echo ""

echo "[3/5] Cleaning up residual configurations..."
apt-get autoremove -y
apt-get autoclean
dpkg --configure -a
echo "✓ Cleanup complete"
echo ""

echo "[4/5] Installing matching NVIDIA 580 driver packages..."
apt-get update
apt-get install -y \
    nvidia-driver-580 \
    libnvidia-gl-580 \
    libnvidia-compute-580 \
    nvidia-utils-580

echo "✓ Driver packages installed"
echo ""

echo "[5/5] Final verification..."
dpkg -l | grep -E "nvidia.*580" | grep "^ii"
echo ""

echo "=========================================="
echo "✓ Fix Complete!"
echo "=========================================="
echo ""
echo "IMPORTANT: You MUST reboot your system now for changes to take effect:"
echo "    sudo reboot"
echo ""
echo "After reboot, verify with:"
echo "    nvidia-smi"
echo ""