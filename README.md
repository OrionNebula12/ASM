# FE-CLib

FE-CLib is a C development setup for writing C code for FE8U.

# macOS Setup

A prototype macOS setup is available for Apple Silicon Macs. It provides a local FE-CLib build pipeline using devkitARM, ARM GCC, the ARM assembler, and a project-local build of lyn 2.5.4.

The setup script verifies the required tools

`./setup-macos.sh`

Once setup is complete, build the project with:

`./build.sh`

The build generates C_Code.lyn.event, which contains the compiled C code output.

To install the code into your FE8U ROM, use Installer.event through FEBuilderGBA's Event Assembler. Installer.event handles the installation of the generated code.

The macOS pipeline has been tested end-to-end, from compiling C code and generating the lyn event to installing it through FEBuilderGBA and verifying the resulting in-game behavior.

The project includes a project-local Apple Silicon build of lyn 2.5.4 at:

`tools/macos/lyn`

For detailed macOS installation and usage instructions, see the accompanying FE8 C Development on macOS guide.

# Status

This macOS setup is currently a prototype for Apple Silicon Macs. The existing Windows workflow is unchanged.

# Credits
Special thanks to Vesly, Laqieer, StanH, Mokha,and Cam.

This work builds on the existing FE8U C/ASM development workflow and the original ASM project and README by Vesly.

- Vesly - for the original project, and permission to adapt the project for this macOS setup.

- Mokha - for the updated FE-CLib.

- Laqieer - for helping fix an Event Assembler bug and creating a Mac version of FEBuilder.

- StanH - for the lyn tool used by the FE-CLib build pipeline.

- Cam - whose conversation kick started the whole project

# AI Disclosure

AI was used extensively as a development and troubleshooting aid, primarily to help adapt the existing Windows workflow to macOS and develop and troubleshoot the macOS setup/build scripts.

The final implementation and testing were performed by me.

# Licenses 
FE-CLib includes and uses lyn version 2.5.4 by StanHash, which is licensed under the GNU General Public License v3.0 (GPL-3.0).

See the included lyn license and the original lyn repository for the applicable license and source code.

# Original README (From Vesly)
ASM hacks for FE8U that I've edited, (re)written, or collaborated on. 
