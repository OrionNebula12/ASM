
.thumb

@ Hooked over the two instructions at UpdateBanimFrame+0x18. It starts the watchdog
@ proc, replays what it displaced, and returns to the instruction after them.
@
@ What gets replayed on FE8 (0x8059A00..0x8059A07):
@     ldr r0, =0x203E104      @ literal lives at 0x8059BE0
@     ldsh r0, [r0, r1]       @ with r1 = 0
@ then the cmp #1 that follows is re-run here too so the flags are right on return.
@
@ Porting this needs three numbers per game:
@   HookReturn   - address of the instruction after the two that were replaced (+1, thumb)
@   LiteralAddr  - the literal-pool word holding the RAM pointer being loaded
@ FE6/FE7 have not been located yet; the .if blocks below are the shape they need.

.global CallStartEndBrokenBattleProc
.type CallStartEndBrokenBattleProc, %function
CallStartEndBrokenBattleProc:
push  {r14}

bl StartEndBrokenBattleProc

.if FE8 == true
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
@ TODO: FE7 equivalent of the two displaced instructions, then return.
pop {r3}
bx r3
.endif

.if FE6 == true
@ TODO: FE6 equivalent of the two displaced instructions, then return.
pop {r3}
bx r3
.endif

.ltorg
