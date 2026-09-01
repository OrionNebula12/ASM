#include "C_Code.h"

void sub_80812C0(void) // MapAnim_StartSubjectDanceAnim
{
    struct Unit * unit = gManimSt.actor[gManimSt.subjectActorId].unit;
    struct MuProc * mu = gManimSt.actor[gManimSt.subjectActorId].mu;
    if (unit->pClassData->number == CLASS_DANCER)
        CallDelayed(sub_8081348, 0x9); // MapAnim_PlayDancerSe
    else
    {
        CallDelayed(sub_8081384, 0xC);                                         // MapAnim_PlayNonDancerSe
        AP_SetDefinition(mu->sprite_anim, (void *)unit_icon_move_Bard_motion); // Bard fallback
    }
    gManimSt.actor[gManimSt.subjectActorId].mu->sprite_anim->frameTimer = 0;
    gManimSt.actor[gManimSt.subjectActorId].mu->sprite_anim->frameInterval = 0x100;
    AP_SwitchAnimation(gManimSt.actor[gManimSt.subjectActorId].mu->sprite_anim, 0x5);
}
