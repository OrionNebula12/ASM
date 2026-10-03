#!/bin/bash

set -e

echo "=== FE-CLib C build ==="
echo

if [ -z "$DEVKITARM" ]; then
    echo "ERROR: DEVKITARM is not set."
    echo "Set it with:"
    echo "  export DEVKITARM=/opt/devkitpro/devkitARM"
    exit 1
fi

LYN="$(cd "$(dirname "$0")" && pwd)/tools/macos/lyn"

for tool in arm-none-eabi-gcc arm-none-eabi-as make; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "ERROR: Required tool not found: $tool"
        exit 1
    fi
done

if [ ! -x "$LYN" ]; then
    echo "ERROR: Project-local lyn not found or not executable:"
    echo "  $LYN"
    echo
    echo "Run ./setup-macos.sh first."
    exit 1
fi

echo "DEVKITARM: $DEVKITARM"
echo "GCC:       $(command -v arm-none-eabi-gcc)"
echo "AS:        $(command -v arm-none-eabi-as)"
echo "LYN:       $LYN"
echo

make C_Code.lyn.event

echo
echo "=== Build successful ==="
echo "Generated: $(pwd)/C_Code.lyn.event"
echo
echo "Next step:"
echo "Open the ROM in FEBuilderGBA and insert the generated event."
