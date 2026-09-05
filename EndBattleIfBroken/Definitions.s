@ Included AFTER the shared ASM/Definitions.s (see Data/FEn_defs.s), which supplies
@ the SET_FUNC/SET_DATA macros, fe8.s, and the Proc_* addresses. Anything re-set here
@ deliberately overrides it - .set allows redefinition and the last one wins.

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

SET_FUNC Proc_End,   0x8003C29   @ corrected, see below

SET_FUNC GetAnimPosition, 0x804B6C5
SET_FUNC EndEfxStatusUnits, 0x8046E9D

@ Proc_End above is NOT the 0x8004265 the shared ASM/Definitions.s uses - that address
@ is Proc_EndEach. FE6 EndEfxStatusUnits (0x8046E9C) compiles its one Proc_End call to
@ "bl 0x8003c28", which settles it.
SET_FUNC Proc_EndEach, 0x8004265

@ RAM, read out of literal pools rather than the library (which indexes functions only).
@ NewEkrBattle and NewEfxHpBar load these; both pools line up slot-for-slot with FE8's,
@ and NewEkrBattle's pool also holds InBattleMainRoutine|1, whose address the library
@ gives independently - so the alignment is proved, not assumed.
SET_DATA gAnims, 0x02000000                @ same in all three games
SET_DATA gEkrBattleEndFlag, 0x0201771C
SET_DATA gEfxHpLutOff, 0x0203CD46
SET_DATA gpProcEfxStatusUnits, 0x02017764

@ FE6 has no DeleteEach6C_efxStatusUnit - EndEfxStatusUnits (0x8046E9C) is followed
@ straight by DisableEfxStatusUnits (0x8046ED8), 0x10 bytes tighter than FE8, which is
@ exactly that function's size. C_Code.c has to call Proc_EndEach on this instead.
SET_DATA ProcScr_efxStatusUnit, 0x85CBA98

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

@ ProcScr_PromoMain is no longer needed - C_Code.c tests gEkrDistanceType instead.
SET_DATA gEkrDistanceType, 0x203CD14
.endif

@ ---------------------------------------------------------------- FE7U
.if FE7 == true
SET_FUNC __aeabi_idiv,    __divsi3
SET_FUNC __aeabi_idivmod, __modsi3
SET_FUNC Div, __divsi3
SET_FUNC Mod, __modsi3

SET_FUNC Proc_End,   0x8004585   @ corrected, see below

SET_FUNC GetAnimPosition, 0x8054679
SET_FUNC EndEfxStatusUnits, 0x804F795

@ Same story as FE6: the shared ASM/Definitions.s gives Proc_End and Proc_EndEach the
@ SAME address (0x800486D), and that address is Proc_EndEach. FE7U EndEfxStatusUnits
@ (0x804F794) calls "bl 0x8004584" for its Proc_End, hence the correction above.
SET_FUNC Proc_EndEach, 0x800486D

SET_DATA gAnims, 0x02000000                @ same in all three games
SET_DATA gEkrBattleEndFlag, 0x02017724     @ same as FE8U
SET_DATA gEfxHpLutOff, 0x0203E05E
SET_DATA ProcScr_efxStatusUnit, 0x8B9AF14

@ FE7 has no DeleteEach6C_efxStatusUnit either.

@ same story as FE6: tails confirmed as 0x804D788 EfxHpBar_MoveCameraOnEnd and
@ 0x804D828 EfxHpBar_WaitCameraMove
SET_DATA gProcScr_efxHPBar, 0x8B9ABC4
SET_DATA gProcScr_efxHPBarResire, 0x8B9ABEC

SET_DATA gProcScr_Talk, 0x8B909D4              @ CALLs Talk_OnInit 0x80081E4
SET_DATA ProcScr_EkrLevelup, 0x8BDB5FC         @ REPEATs EkrLvup_InitPalette 0x8069404
SET_DATA ProcScr_efxWeaponIcon, 0x8B9AF3C      @ REPEATs efxWeaponIcon_Loop 0x804FAD4
SET_DATA ProcScr_efxHPBarColorChange, 0x8B9AECC @ REPEATs EfxHPBarColorChangeMain 0x804F4A0

@ ProcScr_PromoMain is no longer needed - C_Code.c tests gEkrDistanceType instead.
SET_DATA gEkrDistanceType, 0x203E02C
.endif
