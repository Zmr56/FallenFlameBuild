.thumb
.equ WardingGraceID, AuraSkillCheck+4

WTYPE_STAFF       = 0x04
WTYPE_ANIMA       = 0x05
WTYPE_LIGHT	      = 0x06
WTYPE_DARK        = 0x07
GetEquippedWeapon = 0x08016B28+1
GetWeaponType     = 0x08017548+1

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@check for skill (we also check in AuraSkillCheck if the skill holder is using a sword with this skill)
CheckSkill:
ldr r0, AuraSkillCheck
mov lr, r0
mov r0, r4 @attacker
ldr r1, WardingGraceID
mov r2, #3 @can't_trade
mov r3, #1 @range
.short 0xf800
cmp r0, #0
beq End

@ Check attacker is using a magical weapon
@ I'm doing back to back BEQ checks to avoid monster weapons which are (0xB)
mov r0, r4
ldr r3, =GetEquippedWeapon
bl Trampoline
ldr r3, =GetWeaponType
bl Trampoline
cmp r0, #WTYPE_STAFF
beq SubtractAttack
cmp r0, #WTYPE_ANIMA
beq SubtractAttack
cmp r0, #WTYPE_LIGHT
beq SubtractAttack
cmp r0, #WTYPE_DARK
beq SubtractAttack
b 	End

@subtract +8 battle struct ATK from enemy in range of skill holder
SubtractAttack:
mov r1, #0x5a
ldrsh r0, [r4, r1] @atk
sub r0, #8
strh r0, [r4,r1]

End:
pop {r4-r7, r15}

Trampoline:
	bx  r3

.align
.ltorg
AuraSkillCheck:
@Poin AuraSkillCheck
@WORD WardingGraceID
