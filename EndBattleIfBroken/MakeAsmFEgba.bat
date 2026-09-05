@echo off

SET startDir="C:\devkitPro\devkitARM\bin\"
SET as="%startDir%arm-none-eabi-as"
SET LYN="C:\devkitPro\lyn.exe"


@rem NOTE: the source is assembled once PER GAME, inside the blocks below, so that its
@rem .if FE6/FE7/FE8 blocks are actually taken. Assembling it once up here with no
@rem --defsym leaves FE6/FE7/FE8/true/false undefined, every .if evaluates false, and
@rem the same empty .elf then gets reused for all three games.
if exist "%~dp0Data\FE6_defs.s" (
	
	@rem Assemble definitions into a .elf if exists	
	@rem Assemble the source for this game, so its .if blocks are taken
	%as% -g -mcpu=arm7tdmi -mthumb-interwork --defsym true=1 --defsym false=0 --defsym FE6=1 --defsym FE7=0 --defsym FE8=0 "AsmHooks.asm" -o "%~dp0Data\%~n1.elf"

	%as% -g -mcpu=arm7tdmi -mthumb-interwork "%~dp0Data\FE6_defs.s" -o "%~dp0Data\FE6_defs.elf"

	@rem Assebmle into a .lyn.event with definitions
	%LYN% "%~dp0Data\%~n1.elf" "%~dp0Data\FE6_defs.elf" > "%~dp0Data\FE6_AsmHooks.lyn.event"

	@cd %~dp0/Data
	echo y | del "FE6_defs.elf"

) 

@cd %~dp0

if exist "%~dp0Data\FE7_defs.s" (
	
	@rem Assemble definitions into a .elf if exists	
	@rem Assemble the source for this game, so its .if blocks are taken
	%as% -g -mcpu=arm7tdmi -mthumb-interwork --defsym true=1 --defsym false=0 --defsym FE6=0 --defsym FE7=1 --defsym FE8=0 "AsmHooks.asm" -o "%~dp0Data\%~n1.elf"

	%as% -g -mcpu=arm7tdmi -mthumb-interwork "%~dp0Data\FE7_defs.s" -o "%~dp0Data\FE7_defs.elf"

	@rem Assebmle into a .lyn.event with definitions
	%LYN% "%~dp0Data\%~n1.elf" "%~dp0Data\FE7_defs.elf" > "%~dp0Data\FE7_AsmHooks.lyn.event"

	@cd %~dp0/Data
	echo y | del "FE7_defs.elf"

) 

@cd %~dp0
if exist "%~dp0Data\FE8_defs.s" (
	
	@rem Assemble definitions into a .elf if exists	
	@rem Assemble the source for this game, so its .if blocks are taken
	%as% -g -mcpu=arm7tdmi -mthumb-interwork --defsym true=1 --defsym false=0 --defsym FE6=0 --defsym FE7=0 --defsym FE8=1 "AsmHooks.asm" -o "%~dp0Data\%~n1.elf"

	%as% -g -mcpu=arm7tdmi -mthumb-interwork "%~dp0Data\FE8_defs.s" -o "%~dp0Data\FE8_defs.elf"

	@rem Assebmle into a .lyn.event with definitions
	%LYN% "%~dp0Data\%~n1.elf" "%~dp0Data\FE8_defs.elf" > "%~dp0Data\FE8_AsmHooks.lyn.event"

	@cd %~dp0/Data
	echo y | del "FE8_defs.elf"

) 


echo y | del "%~n1.elf"

pause