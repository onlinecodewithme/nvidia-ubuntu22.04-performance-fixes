#!/bin/bash
# RViz GPU Acceleration Setup Script

echo "=========================================="
echo "RViz GPU Acceleration Optimization"
echo "=========================================="
echo ""

# Backup existing bashrc
cp ~/.bashrc ~/.bashrc.backup_$(date +%Y%m%d_%H%M%S)
echo "✓ Backed up .bashrc"

# Add GPU acceleration settings to bashrc
cat >> ~/.bashrc << 'EOF'

# ========== NVIDIA GPU Acceleration for RViz ==========
# Added on $(date)
export LIBGL_ALWAYS_SOFTWARE=0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export RVIZ_PERFORMANCE_MODE=1
# ======================================================

EOF

echo "✓ Added GPU acceleration settings to ~/.bashrc"
echo ""

# Apply changes to current session
export LIBGL_ALWAYS_SOFTWARE=0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export RVIZ_PERFORMANCE_MODE=1

echo "✓ Applied settings to current session"
echo ""

# Verify OpenGL setup
echo "Verifying OpenGL configuration..."
if command -v glxinfo &> /dev/null; then
    echo ""
    echo "OpenGL Vendor:"
    glxinfo | grep "OpenGL vendor"
    echo ""
    echo "Direct Rendering:"
    glxinfo | grep "direct rendering"
else
    echo "⚠ glxinfo not found. Install with: sudo apt-get install mesa-utils"
fi

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "To apply changes in new terminals, run:"
echo "    source ~/.bashrc"
echo ""
echo "To test RViz with GPU acceleration:"
echo "    nvidia-smi  # Check GPU status"
echo "    rviz        # For ROS1"
echo "    ros2 run rviz2 rviz2  # For ROS2"
echo ""
echo "Monitor GPU usage while RViz runs:"
echo "    watch -n 1 nvidia-smi"
echo ""