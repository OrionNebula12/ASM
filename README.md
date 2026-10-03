# FE-CLib

FE-CLib is the C development setup used for writing C code for FE8U.

macOS setup

A macOS setup is currently available as a prototype for Apple Silicon Macs.

The macOS setup provides a local build environment using:

devkitARM

ARM GCC

ARM assembler

lyn 2.5.4

FE-CLib's C build system

Requirements

macOS on Apple Silicon

Xcode Command Line Tools

Homebrew

devkitPro with devkitARM and the GBA development tools

FEBuilderGBA for inserting the generated event into a ROM

Setup

From the FE-CLib_2025 directory, run:

./setup-macos.sh


The setup script checks the required development tools and performs a test build.

Building

After setup, C code can be built with:

./build.sh


The build produces:

C_Code.lyn.event


The generated event can then be used with the FE-CLib installation workflow in FEBuilderGBA.

Status

The macOS setup is currently a prototype intended for Apple Silicon Macs.

The existing Windows workflow is unchanged. Cross-platform support can be addressed separately once the macOS setup has been further tested.

## Original README From Vesly
# ASM

ASM hacks for FE8U that I've edited, (re)written, or collaborated on.