

#include "C_Code.h" // headers
#define PUREFUNC __attribute__((pure))
int Mod(int a, int b) PUREFUNC;
extern const struct ProcCmd gProcScr_Talk[];
// arrays, not pointers: FE8 used to define these as ROM words that happen to hold the
// script address, but FE6/FE7 have no such word, so Definitions.s points every game
// straight at the script instead.
extern const struct ProcCmd gProcScr_efxHPBar[];
extern const struct ProcCmd gProcScr_efxHPBarResire[];

extern int MaxNumberOfFrames;

// Promotion inside the battle-animation sequence is flagged by gEkrDistanceType, not by
// a proc that can be searched for: EkrLvup_OnPrepare sets its is_promotion from exactly
// this test. Cheaper than the old Proc_Find(ProcScr_PromoMain), and it ports - FE6/FE7
// build ProcScr_PromoMain differently enough that nothing in either ROM references
// PromoMain_InitScreen, but gEkrDistanceType is already known for all three.
extern s16 gEkrDistanceType;
#define EKR_DISTANCE_PROMOTION 4

// FE6/FE7 have no DeleteEach6C_efxStatusUnit - it is an FE8 addition (their
// EndEfxStatusUnits is followed straight by DisableEfxStatusUnits, 0x10 bytes tighter).
// It was only ever Proc_EndEach on this script, so do that directly everywhere.
// ProcScr_efxStatusUnit and Proc_EndEach are already declared by the FE-Clib headers.

typedef struct
{
    /* 00 */ PROC_HEADER;
    int timer;
    int hpBarTimer;
    int roundId;
} EndBrokenBattleProc;
void LoopEndBrokenBattleProc(EndBrokenBattleProc * proc);
const struct ProcCmd EndBrokenBattleProcCmd[] = {
    PROC_NAME("EndBrokenBattleProcName"),
    PROC_YIELD,
    PROC_REPEAT(LoopEndBrokenBattleProc),
    PROC_END,
};

void StartEndBrokenBattleProc(void)
{
    EndBrokenBattleProc * proc;
    proc = Proc_Find(EndBrokenBattleProcCmd);
    if (!proc)
    {
        proc = Proc_Start(EndBrokenBattleProcCmd, (void *)3);
    }
    proc->timer = 0;
    proc->hpBarTimer = 0;
    proc->roundId = 0xFF;
}

int HitNowBrokenBattle(EndBrokenBattleProc * proc, struct ProcEfxHPBar * HpProc)
{
    if (!HpProc)
    {
        return false;
    }
    return true;
}

void EndBattle(EndBrokenBattleProc * proc)
{
    Proc_End(proc);

    struct Anim * anim;
    gEkrBattleEndFlag = true; // immediately ends without waiting for anything

    anim = gAnims[2];
    if (anim)
        EndEfxStatusUnits(anim);

    anim = gAnims[0];
    if (anim)
        EndEfxStatusUnits(anim);

    ProcPtr otherProc = Proc_Find(ProcScr_efxWeaponIcon);
    if (otherProc)
    {
        Proc_End(otherProc);
    }

    otherProc = Proc_Find(ProcScr_efxHPBarColorChange);
    if (otherProc)
    {
        Proc_End(otherProc);
    }

    Proc_EndEach(ProcScr_efxStatusUnit);
}

void LoopEndBrokenBattleProc(EndBrokenBattleProc * proc)
{
    if (Proc_Find(gProcScr_Talk))
    {
        return;
    } // wait for battle / death quotes
    if (Proc_Find(ProcScr_EkrLevelup))
    {
        return;
    }
    if (gEkrDistanceType == EKR_DISTANCE_PROMOTION)
    {
        return;
    }
    asm("mov r11, r11");
    proc->timer++;
    struct Anim *anim, *anim2;
    anim = gAnims[GetAnimPosition(anim) * 2];
    anim2 = gAnims[GetAnimPosition(anim) * 2 + 1];
    int roundId = proc->roundId;
    proc->roundId = anim->nextRoundId > anim2->nextRoundId ? anim->nextRoundId - 1 : anim2->nextRoundId - 1;
    if (roundId != proc->roundId)
    {
        proc->timer = 0;
        proc->hpBarTimer = 0;
    }
    struct ProcEfxHPBar * HpProc = Proc_Find(gProcScr_efxHPBarResire);
    if (!HpProc)
    {
        HpProc = Proc_Find(gProcScr_efxHPBar);
    }
    if (HitNowBrokenBattle(proc, HpProc))
    {
        if (proc->timer > 1)
        {
            proc->hpBarTimer = 0;
        }
        proc->timer = 0;
        proc->hpBarTimer++;
    }
    if ((proc->timer > MaxNumberOfFrames) || (proc->hpBarTimer > MaxNumberOfFrames))
    {
        EndBattle(proc);
    }
}

/*
#define A_BUTTON        0x0001
#define B_BUTTON        0x0002
#define SELECT_BUTTON   0x0004
#define START_BUTTON    0x0008
#define DPAD_RIGHT      0x0010
#define DPAD_LEFT       0x0020
#define DPAD_UP         0x0040
#define DPAD_DOWN       0x0080
*/
