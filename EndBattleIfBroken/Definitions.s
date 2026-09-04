.macro SET_FUNC name, value
	.global \name
	.type   \name, function
	.set    \name, \value
.endm

.macro SET_DATA name, value
	.global \name
	.type   \name, object
	.set    \name, \value
.endm

@ Function addresses below come from laqieer's FE_GBA_Function_Library
@ (https://laqieer.github.io/FE_GBA_Function_Library/), which is generated from the
@ FE6 and FE8 decompilation projects. It lists them without the thumb bit, so every
@ SET_FUNC here is the library value + 1.
@
@ It indexes functions only, not data, so the proc SCRIPTS were located by searching
@ each ROM for a ProcCmd (CALL/REPEAT/SET_END_CB) pointing at a routine the library
@ DOES name, then walking back to the start of the script. Every one of them was run
@ against FE8 first as a control and reproduced decomp/fireemblem8.map exactly.
@
@ The FE7 column used is FE7U - confirmed by MainUpdateEkrBattle, which the library
@ gives as FE7U 0x804B328, matching the 0x804B329 already in the shared Definitions.s
@ (FE7J would be 0x804BB04).

@ ---------------------------------------------------------------- FE8
.if FE8 == true
.include "fe8.s"

@ division & other libgcc functions
SET_FUNC __aeabi_idiv,    __divsi3
SET_FUNC __aeabi_idivmod, __modsi3
SET_FUNC Div, __divsi3
SET_FUNC Mod, __modsi3

SET_FUNC GetSoloAnimPreconfType, 0x802ca71
SET_DATA gEfxHpLutOff, 0x203e152
SET_DATA gEkrGaugeDmg, 0x203e1bc
SET_DATA classTablePoin, 0x8017AB8
SET_DATA gBanimExpGain, 0x203e1c8

@ These used to point at ROM words that happen to CONTAIN the script addresses
@ (0x8052354 holds 0x85B9604), which only worked because C_Code.c declared them as
@ pointers. FE6/FE7 have no such convenient word, so they are declared as arrays now
@ and every game points straight at the script.
SET_DATA gProcScr_efxHPBar, 0x85B9604
SET_DATA gProcScr_efxHPBarResire, 0x85B962C
.endif

@ ---------------------------------------------------------------- FE6
.if FE6 == true
SET_FUNC __aeabi_idiv,    __divsi3
SET_FUNC __aeabi_idivmod, __modsi3
SET_FUNC Div, __divsi3
SET_FUNC Mod, __modsi3

SET_FUNC Proc_Start, 0x8003a05
SET_FUNC Proc_Find,  0x8003e7d
SET_FUNC Proc_End,   0x8004265

SET_FUNC GetAnimPosition, 0x804B6C5
SET_FUNC EndEfxStatusUnits, 0x8046E9D

@ efxHPBar/Resire were found before the library, by structure: Resire sits right after
@ efxHPBar and reuses its last two routines. The library then confirmed both tails -
@ 0x8044C68 EfxHpBar_MoveCameraOnEnd, 0x8044D08 EfxHpBar_WaitCameraMove.
SET_DATA gProcScr_efxHPBar, 0x85CB730
SET_DATA gProcScr_efxHPBarResire, 0x85CB758

SET_DATA gProcScr_Talk, 0x85C3D04              @ CALLs Talk_OnInit 0x8009524
SET_DATA ProcScr_EkrLevelup, 0x86061AC         @ REPEATs EkrLvup_InitPalette 0x805DA38
SET_DATA ProcScr_efxWeaponIcon, 0x85CBAC0      @ REPEATs efxWeaponIcon_Loop 0x8047268

@ The library has no FE6 EfxHPBarColorChangeMain, but this script REPEATs 0x8046B7C,
@ which is EndEfxHPBarColorChange + 0x34 - the same gap the two functions have in FE7U
@ (0x804F46C -> 0x804F4A0). Structural scanning independently picked the same script.
SET_DATA ProcScr_efxHPBarColorChange, 0x85CBA50

@ TODO for FE6:
@ SET_DATA gAnims,                       @ RAM; the library indexes functions only
@ SET_DATA gEkrBattleEndFlag,            @ RAM; likewise
@ SET_FUNC DeleteEach6C_efxStatusUnit,   @ library maps FE8U 0x8054B54 only,
@                                        @ "ambiguous legacy cross-game mapping rejected"
@ SET_DATA ProcScr_PromoMain,            @ nothing in the ROM references PromoMain_InitScreen
@                                        @ (0x8094460), so the promo screen is built differently
@ Hook site: UpdateBanimFrame is 0x804B048, so the FE8 hook point (function + 0x18)
@ would be 0x804B060 - but the two displaced instructions still need disassembling
@ before EndBattleIfBroken.asm can replay them.
.endif

@ ---------------------------------------------------------------- FE7U
.if FE7 == true
SET_FUNC __aeabi_idiv,    __divsi3
SET_FUNC __aeabi_idivmod, __modsi3
SET_FUNC Div, __divsi3
SET_FUNC Mod, __modsi3

SET_FUNC Proc_Start, 0x8004495
SET_FUNC Proc_Find,  0x80046A9
SET_FUNC Proc_End,   0x800486D

SET_FUNC GetAnimPosition, 0x8054679
SET_FUNC EndEfxStatusUnits, 0x804F795

@ same story as FE6: tails confirmed as 0x804D788 EfxHpBar_MoveCameraOnEnd and
@ 0x804D828 EfxHpBar_WaitCameraMove
SET_DATA gProcScr_efxHPBar, 0x8B9ABC4
SET_DATA gProcScr_efxHPBarResire, 0x8B9ABEC

SET_DATA gProcScr_Talk, 0x8B909D4              @ CALLs Talk_OnInit 0x80081E4
SET_DATA ProcScr_EkrLevelup, 0x8BDB5FC         @ REPEATs EkrLvup_InitPalette 0x8069404
SET_DATA ProcScr_efxWeaponIcon, 0x8B9AF3C      @ REPEATs efxWeaponIcon_Loop 0x804FAD4
SET_DATA ProcScr_efxHPBarColorChange, 0x8B9AECC @ REPEATs EfxHPBarColorChangeMain 0x804F4A0

@ TODO for FE7U:
@ SET_DATA gAnims,
@ SET_DATA gEkrBattleEndFlag,
@ SET_FUNC DeleteEach6C_efxStatusUnit,
@ SET_DATA ProcScr_PromoMain,
@ Hook site: the library has no FE7 mapping for UpdateBanimFrame at all (FE7J and FE7U
@ are both 0 in its table), so that one needs finding by hand.
.endif
