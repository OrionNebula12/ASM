
.thumb 
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
@ Hooked over the first four instructions of NewEkrBattleDeamon, which runs exactly once
@ when a battle animation begins (it spawns the battle daemon proc and locks the game).
@ That is a better fit than the old UpdateBanimFrame hook: it is a start-of-battle event
@ rather than a per-frame one, and its prologue is the same four instructions in all
@ three games -
@
@     push {r4, lr}
@     ldr  r4, [pc, #28]     @ &gpProcEkrBattleDeamon
@     ldr  r0, [pc, #28]     @ gProc_ekrBattleDeamon
@     movs r1, #3            @ PROC_TREE_3
@
@ - exactly 8 bytes, which is what jumpToHack replaces. Both PC-relative loads are
@ replayed here as absolute constants read out of each ROM's literal pool, so nothing
@ depends on where this stub lands. lr is pushed before the bl, and the original epilogue
@ (pop {r4} / pop {r0} / bx r0) still does the unwinding.

.global CallStartEndBrokenBattleProcFE7
.type CallStartEndBrokenBattleProcFE7, %function
CallStartEndBrokenBattleProcFE7:
push {lr} 
bl StartEndBrokenBattleProc      
ldr r0, =0x08B9A99C
movs r1, #3
blh 0x8004494 
str r0, [r4] 
ldr r1, =0x203e000 
pop {r3} 
bx r3 
@
@
@.global CallStartEndBrokenBattleProcFE8
@.type CallStartEndBrokenBattleProcFE8, %function
@CallStartEndBrokenBattleProcFE8:
@push {lr} 
@ldr r0, =0x08B9A99C
@movs r1, #3
@blh 0x8004494 
@str r0, [r4] 
@ldr r1, =0x203e000 
@pop {r3} 
@bx r3 
@
@.global CallStartEndBrokenBattleProcFE6
@.type CallStartEndBrokenBattleProcFE6, %function
@CallStartEndBrokenBattleProcFE6:
@push {lr} 
@ldr r0, =0x08B9A99C
@movs r1, #3
@blh 0x8004494 
@str r0, [r4] 
@ldr r1, =0x203e000 
@pop {r3} 
@bx r3 


.global CallStartEndBrokenBattleProc
.type CallStartEndBrokenBattleProc, %function
CallStartEndBrokenBattleProc:
.if FE8 == true
push {r4, lr}                    @ the prologue we displaced
bl StartEndBrokenBattleProc      @ clobbers lr, which is already on the stack
ldr r4, =0x0203E0F8              @ &gpProcEkrBattleDeamon
ldr r0, =0x085B9358              @ gProc_ekrBattleDeamon
movs r1, #3
ldr r3, =0x0804FD69              @ back to the bl Proc_Start we stopped short of
bx r3
.endif

.if FE7 == true
push {lr} 
ldr r0, =0x08B9A99C
movs r1, #3
blh 0x8004494 
str r0, [r4] 
ldr r1, =0x203e000 
pop {r3} 
bx r3 

.endif

.if FE6 == true
ldr r4, =0x0203CCEC
ldr r0, =0x085CB508
movs r1, #3
ldr r3, =0x0804258D
bx r3
.endif

.ltorg
