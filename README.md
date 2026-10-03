# FE-CLib

FE-CLib is the C development setup used for writing C code for FE8U.

# macOS setup

A macOS setup is currently available as a prototype for Apple Silicon Macs.

The macOS setup provides a local build environment using:

devkitARM

ARM GCC

ARM assembler

lyn 2.5.4

FE-CLib's C build system

This setup is currently intended for development and testing on macOS with Apple Silicon.

Requirements

You will need:

macOS on Apple Silicon

Xcode Command Line Tools

Homebrew

devkitPro with devkitARM

the devkitPro GBA development tools

FEBuilderGBA for inserting the generated code into a ROM

Setup

Open Terminal and enter the FE-CLib_2025 directory:

cd FE-CLib_2025


Run the setup script:

./setup-macos.sh


The setup script checks that the required development tools are installed and verifies the project-local lyn executable.

It also performs a complete test build to make sure the C compiler, ARM assembler, and lyn pipeline are working.

If setup succeeds, the macOS environment is ready to build FE-CLib C code.

Building

After setup, build the C code with:

./build.sh


# The build process:

Compiles the C source with ARM GCC.

Converts the generated assembly into an ARM object file.

Links the object with the FE-CLib definitions.

Runs lyn to generate the FEBuilder event output.

The generated file is:

C_Code.lyn.event


The generated event is build output and can be regenerated at any time by running the build again.

Installing into FEBuilderGBA

The FE-CLib project also contains an Installer.event file used by the FEBuilder installation workflow.

The tested workflow is:

Build the C code with ./build.sh.

Open the target FE8U ROM in FEBuilderGBA.

Use the FE-CLib installation workflow with Installer.event.

Let FEBuilder compile and insert the installer event.

Test the resulting ROM.

Important: C_Code.lyn.event and Installer.event have different purposes.

C_Code.lyn.event is the generated output from the C build pipeline.

Installer.event is the event used by the tested FEBuilder installation workflow.

# Testing

The macOS C pipeline has been tested by compiling a C routine, generating the corresponding lyn event, inserting the installation event through FEBuilderGBA, and testing the resulting ROM.

The test confirmed that changes made to the C implementation affected the corresponding in-game behavior.

Project-local lyn

The macOS prototype includes its own project-local lyn executable:

tools/macos/lyn


The bundled version is lyn 2.5.4 and is built for Apple Silicon.

The project uses this local executable instead of requiring users to install lyn separately.

Status

The macOS setup is currently a prototype intended for Apple Silicon Macs.

The existing Windows workflow is unchanged.

Cross-platform support can be addressed separately after the macOS setup has been further tested.

This prototype is being developed and tested independently before being considered for wider distribution.

# AI Disclosure 
AI had been heavily used to help make this work. 

## Original README From Vesly
# ASM

ASM hacks for FE8U that I've edited, (re)written, or collaborated on.