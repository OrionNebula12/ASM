
.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm

@ ---------------------------------------------------------------------------------
@ FE8 hooks UpdateBanimFrame, exactly as it always did - jumpToHack over the 8 bytes
@ at 0x8059A00, replaying them and returning to 0x8059A08.
@
@ FE6/FE7 hook NewEkrBattleDeamon instead, which runs once when a battle animation
@ starts. Their prologue is the same in both games:
@
@     +0  push {r4, lr}
@     +2  ldr  r4, [pc, #28]     @ &gpProcEkrBattleDeamon   <- left alone
@     +4  ldr  r0, [pc, #28]     @ gProc_ekrBattleDeamon    <- hook starts here
@     +6  movs r1, #3            @ PROC_TREE_3
@     +8  bl   Proc_Start
@     +C  str  r0, [r4]
@     +E  ldr  r1, [pc, #24]     @ &gBattleDeamonActive
@
@ callHackNew takes 12 bytes, so hooking at +4 covers +4..+F exactly, and r4 is
@ already loaded by the instruction before it. Both displaced PC-relative loads are
@ replayed as absolute constants read out of each ROM's literal pool.
@ ---------------------------------------------------------------------------------

.global CallStartEndBrokenBattleProc
.type CallStartEndBrokenBattleProc, %function
CallStartEndBrokenBattleProc:

.if FE8 == true
push  {r14}
bl StartEndBrokenBattleProc
ldr r0, =0x8059BE0
ldr r0, [r0] @ 0x203e104
mov r1, #0
ldsh r0, [r0, r1]
cmp r0, #1

pop {r3}
ldr r3, =0x8059a09
bx r3
.endif

.if FE7 == true
push {lr}
bl StartEndBrokenBattleProc
ldr r0, =0x08B9A99C      @ gProc_ekrBattleDeamon
movs r1, #3              @ PROC_TREE_3
blh 0x8004494            @ Proc_Start
str r0, [r4]             @ gpProcEkrBattleDeamon; r4 set by the ldr we left in place
ldr r1, =0x0203E000      @ &gBattleDeamonActive
pop {r3}
bx r3
.endif

.if FE6 == true
push {lr}
bl StartEndBrokenBattleProc
ldr r0, =0x085CB508      @ gProc_ekrBattleDeamon
movs r1, #3              @ PROC_TREE_3
blh 0x8003A04            @ Proc_Start
str r0, [r4]             @ gpProcEkrBattleDeamon; r4 set by the ldr we left in place
ldr r1, =0x0203CCE8      @ &gBattleDeamonActive
pop {r3}
bx r3
.endif

.ltorg
