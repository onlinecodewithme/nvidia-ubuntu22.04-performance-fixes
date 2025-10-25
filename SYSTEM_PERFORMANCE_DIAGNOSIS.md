# System Performance Diagnosis and Fix

## Problem Summary
Your system slowness (especially with RViz) is caused by an **NVIDIA driver version mismatch**.

## Root Cause Analysis

### ❌ Critical Issue: Driver/Library Version Mismatch
```
Kernel Driver:    580.95.05
NVIDIA Libraries: 570.195.03
NVML Library:     570.195
```

**Impact:** This mismatch prevents GPU acceleration, forcing RViz and other graphics applications to use slow CPU-based software rendering instead of your GPU.

### ✅ System Resources (Normal)
- **Memory:** 60GB total, 51GB free (healthy)
- **CPU:** Low usage, load average: 0.56
- **Disk:** 1.4TB available (25% used, healthy)
- **No RViz processes currently running**

## Solution

### Option 1: Automated Fix (Recommended)
I've created a fix script that will:
1. Backup current driver list
2. Remove conflicting 550/570 driver packages
3. Install matching 580 driver packages
4. Clean up system

**To run:**
```bash
sudo bash fix_nvidia_driver.sh
sudo reboot
```

### Option 2: Manual Fix
```bash
# Remove old packages
sudo apt-get remove --purge -y libnvidia-cfg1-570 libnvidia-compute-570 libnvidia-decode-570

# Remove 550 series
sudo apt-get remove --purge -y 'nvidia-*-550' 'libnvidia-*-550'

# Install matching 580 packages
sudo apt-get update
sudo apt-get install -y nvidia-driver-580 libnvidia-gl-580 libnvidia-compute-580

# Reboot
sudo reboot
```

## Verification Steps (After Reboot)

1. **Check driver status:**
```bash
nvidia-smi
```
Expected: Should show GPU info without errors

2. **Verify version match:**
```bash
cat /proc/driver/nvidia/version
```
Expected: Should show version 580.95.05

3. **Test RViz:**
```bash
rosrun rviz rviz
```
Expected: Should open quickly with GPU acceleration

## Additional Optimizations

### For RViz Performance
Add to `~/.bashrc`:
```bash
# Force OpenGL rendering for RViz
export LIBGL_ALWAYS_SOFTWARE=0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

### Clean up old kernel modules
After fixing and verifying the driver works:
```bash
# Remove old kernel module packages
sudo apt-get autoremove -y 'linux-modules-nvidia-550*'
sudo apt-get autoremove -y 'linux-objects-nvidia-550*'
```

## Why This Happened

This typically occurs when:
- System updates installed a newer kernel driver (580) but didn't upgrade all libraries
- Partial package upgrade left mixed versions
- Manual driver installation created conflicts

## Prevention

To avoid future issues:
```bash
# Always keep NVIDIA packages in sync
sudo apt-get install -f
sudo apt-get update && sudo apt-get upgrade
```

## Expected Results After Fix

- ✅ RViz will use GPU acceleration (10-100x faster)
- ✅ System responsiveness restored
- ✅ No more "Driver/library version mismatch" errors
- ✅ Smooth graphics rendering in all applications

## Need Help?

If issues persist after reboot:
1. Check for kernel updates: `uname -r` should be 6.8.0-85
2. Verify secure boot is disabled (if applicable)
3. Check GPU detection: `lspci | grep -i nvidia`

---

**Created:** 2025-10-25  
**Status:** Ready to apply