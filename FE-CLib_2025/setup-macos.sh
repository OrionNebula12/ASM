#!/bin/bash

set -e

echo "======================================"
echo " FE-CLib macOS Setup"
echo "======================================"
echo

# --------------------------------------
# Basic system checks
# --------------------------------------

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "ERROR: This setup script is for macOS."
    exit 1
fi

ARCH="$(uname -m)"

if [[ "$ARCH" != "arm64" ]]; then
    echo "WARNING: This setup is designed for Apple Silicon."
    echo "Detected architecture: $ARCH"
    echo
fi

echo "✓ macOS detected"
echo "✓ Architecture: $ARCH"

# --------------------------------------
# Apple Command Line Tools
# --------------------------------------

if xcode-select -p >/dev/null 2>&1; then
    echo "✓ Xcode Command Line Tools"
else
    echo
    echo "ERROR: Xcode Command Line Tools are not installed."
    echo
    echo "Install them with:"
    echo "  xcode-select --install"
    echo
    exit 1
fi

# --------------------------------------
# Homebrew
# --------------------------------------

if command -v brew >/dev/null 2>&1; then
    echo "✓ Homebrew: $(command -v brew)"
else
    echo
    echo "ERROR: Homebrew is not installed."
    echo
    echo "Install Homebrew from:"
    echo "  https://brew.sh/"
    echo
    exit 1
fi

# --------------------------------------
# devkitPro / devkitARM
# --------------------------------------

DEVKITPRO="${DEVKITPRO:-/opt/devkitpro}"
DEVKITARM="${DEVKITARM:-$DEVKITPRO/devkitARM}"

if [[ ! -d "$DEVKITPRO" ]]; then
    echo
    echo "ERROR: devkitPro was not found."
    echo "Expected: $DEVKITPRO"
    echo
    exit 1
fi

echo "✓ devkitPro: $DEVKITPRO"

if [[ ! -d "$DEVKITARM" ]]; then
    echo
    echo "ERROR: devkitARM was not found."
    echo "Expected: $DEVKITARM"
    echo
    exit 1
fi

echo "✓ devkitARM: $DEVKITARM"

# --------------------------------------
# devkitPro package manager
# --------------------------------------

DKP_PACMAN="$(command -v dkp-pacman || true)"

if [[ -z "$DKP_PACMAN" ]]; then
    echo
    echo "ERROR: dkp-pacman was not found."
    echo
    echo "devkitPro's package manager is required to install"
    echo "the GBA development tools."
    echo
    exit 1
fi

echo "✓ dkp-pacman: $DKP_PACMAN"

# Check that the GBA development group is installed.
if "$DKP_PACMAN" -Qg gba-dev >/dev/null 2>&1; then
    echo "✓ gba-dev development group"
else
    echo
    echo "ERROR: gba-dev development group is not installed."
    echo
    echo "Install it with:"
    echo "  sudo dkp-pacman -S gba-dev"
    echo
    exit 1
fi


# --------------------------------------
# ARM toolchain
# --------------------------------------

ARM_GCC="$DEVKITARM/bin/arm-none-eabi-gcc"
ARM_AS="$DEVKITARM/bin/arm-none-eabi-as"
ARM_OBJCOPY="$DEVKITARM/bin/arm-none-eabi-objcopy"

if [[ ! -x "$ARM_GCC" ]]; then
    echo "ERROR: devkitARM GCC not found:"
    echo "  $ARM_GCC"
    exit 1
fi

if [[ ! -x "$ARM_AS" ]]; then
    echo "ERROR: devkitARM assembler not found:"
    echo "  $ARM_AS"
    exit 1
fi

if [[ ! -x "$ARM_OBJCOPY" ]]; then
    echo "ERROR: devkitARM objcopy not found:"
    echo "  $ARM_OBJCOPY"
    exit 1
fi

echo "✓ ARM GCC: $("$ARM_GCC" --version | head -1)"
echo "✓ ARM assembler"
echo "✓ ARM objcopy"

echo
echo "======================================"
echo " Basic environment checks passed"
echo "======================================"

# --------------------------------------
# FE-CLib project checks
# --------------------------------------

echo
echo "======================================"
echo " Checking FE-CLib project"
echo "======================================"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

REQUIRED_FILES=(
    "C_Code.c"
    "C_Code.h"
    "Definitions.s"
    "Makefile"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$PROJECT_ROOT/$file" ]]; then
        echo "ERROR: Required file not found:"
        echo "  $PROJECT_ROOT/$file"
        exit 1
    fi

    echo "✓ $file"
done

if [[ ! -d "$PROJECT_ROOT/include" ]]; then
    echo "ERROR: include directory not found:"
    echo "  $PROJECT_ROOT/include"
    exit 1
fi

echo "✓ include/"

# --------------------------------------
# Project-local lyn
# --------------------------------------

LYN="$PROJECT_ROOT/tools/macos/lyn"
LYN_VERSION="2.5.4"

if [[ ! -f "$LYN" ]]; then
    echo
    echo "ERROR: Project-local lyn was not found."
    echo "Expected:"
    echo "  $LYN"
    echo
    exit 1
fi

if [[ ! -x "$LYN" ]]; then
    echo
    echo "ERROR: Project-local lyn is not executable."
    echo "Run:"
    echo "  chmod +x \"$LYN\""
    echo
    exit 1
fi

if [[ "$(uname -m)" == "arm64" ]]; then
    if ! file "$LYN" | grep -q "Mach-O 64-bit executable arm64"; then
        echo
        echo "ERROR: Project-local lyn is not an Apple Silicon executable."
        file "$LYN"
        echo
        exit 1
    fi
fi

echo "✓ lyn: $LYN"

LYN_OUTPUT="$("$LYN" 2>&1 || true)"

if printf '%s\n' "$LYN_OUTPUT" | grep -q "lyn $LYN_VERSION usage"; then
    echo "✓ lyn executable: $LYN_VERSION"
else
    echo
    echo "ERROR: Project-local lyn could not be verified."
    echo "$LYN_OUTPUT"
    exit 1
fi

# --------------------------------------
# Test FE-CLib build
# --------------------------------------


echo
echo "======================================"
echo " Testing FE-CLib build"
echo "======================================"

cd "$PROJECT_ROOT"

echo "Removing previous build output..."

rm -f \
    "$PROJECT_ROOT/C_Code.lyn.event" \
    "$PROJECT_ROOT/C_Code.s" \
    "$PROJECT_ROOT/C_Code.o" \
    "$PROJECT_ROOT/Definitions.o"

echo "✓ Previous build output removed"

echo
echo "Building C_Code.lyn.event..."

if ! make C_Code.lyn.event; then
    echo
    echo "ERROR: FE-CLib build failed."
    exit 1
fi

if [[ ! -f "$PROJECT_ROOT/C_Code.lyn.event" ]]; then
    echo
    echo "ERROR: Build completed but C_Code.lyn.event was not produced."
    exit 1
fi

if [[ ! -s "$PROJECT_ROOT/C_Code.lyn.event" ]]; then
    echo
    echo "ERROR: C_Code.lyn.event was produced but is empty."
    exit 1
fi

if ! grep -q '^PUSH' "$PROJECT_ROOT/C_Code.lyn.event"; then
    echo
    echo "ERROR: C_Code.lyn.event does not appear to contain valid lyn output."
    exit 1
fi

echo
echo "✓ C compilation"
echo "✓ ARM assembly"
echo "✓ lyn conversion"
echo "✓ C_Code.lyn.event generated"
echo "✓ Valid lyn event output"

echo
echo "Generated:"
ls -lh "$PROJECT_ROOT/C_Code.lyn.event"

echo
echo "======================================"
echo " FE-CLib macOS setup successful"
echo "======================================"

echo
echo "You can now build with:"
echo
echo "  ./build.sh"
