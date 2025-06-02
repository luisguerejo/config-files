#!/bin/bash
export WLR_RENDERER=vulkan
export QT_QPA_PLATFORM=wayland
export XWAYLAND_NO_GLAMOR=1
export WLR_NO_HARDWARE_CURSORS=1
export XDG_CURRENT_DESKTOP=sway
sway --unsupported-gpu
