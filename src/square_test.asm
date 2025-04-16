/*******************************************************************************
 * Apache License, Version 2.0
 * Copyright (c) 2025 chciken/Niko
 ******************************************************************************/

DEF rP1 EQU $FF00
DEF rNR10 EQU $FF10
DEF rNR11 EQU $FF11
DEF rNR12 EQU $FF12
DEF rNR13 EQU $FF13
DEF rNR14 EQU $FF14
DEF rAUDVOL EQU $FF24
DEF rAUDTERM EQU $FF25
DEF rAUDENA EQU $FF26
DEF rLCDC EQU $FF40
DEF rSTAT EQU $FF41
DEF rLY EQU $FF44
DEF rBGP EQU $FF47

DEF STATF_OAM EQU  %00000010
def TileDataLow EQU $8000
def FontDataVram EQU $8000
def LogoDataVram EQU $8300
def CHAR_OFFSET EQU $37
def REG_X_ALIGN EQU 2
def VALUE_X_ALIGN EQU 18
def Y_ALIGN EQU 5
def NUM_OPTS EQU 11

def SIZE_FONT_DATA EQU 41 ; Size in tiles.
def SIZE_LOGO_DATA EQU 80 ; Size in tiles.
def NUM_PRESETS EQU 10
def POINTER_INDEX EQU $28

def MASK_BUTTON_A EQU %1
def MASK_BUTTON_B EQU %10
def MASK_BUTTON_SELECT EQU %100
def MASK_BUTTON_START EQU %1000
def MASK_BUTTON_RIGHT EQU %10000
def MASK_BUTTON_LEFT EQU %100000
def MASK_BUTTON_UP EQU %1000000
def MASK_BUTTON_DOWN EQU %10000000

def JoyPadData EQU $c100
def JoyPadNewPresses EQU $c101
def PointerIndexY EQU $c102
def CursorIndex EQU $c103 ; 0 -> period sweep, 1 -> negate, 2 -> shift, 3 -> duty, 4 -> length, 5 -> init volume, 6 -> envelope, 7 -> period envelope, 8 -> frequency, 9 -> length enable, 10 -> play
def PresetIndex EQU $c104
def FastScrollTimer EQU $c105

def RegBase EQU $c110
def RegSweepPeriod EQU $c110 ; 0-7
def RegNegate EQU $c111 ; 0-1
def RegShift EQU $c112 ; 0-7
def RegDuty EQU $c113 ; 0-3
def RegLength EQU $c114 ; 0-63
def RegInitVolume EQU $c115 ; 0-15
def RegEnvelope EQU $c116 ; 0-1
def RegPeriod EQU $c117 ; 0-7
def RegFrequency EQU $c118 ;
def RegLengthEnable EQU $c119 ; 0-1

def RegFrequency0 EQU $c300 ; Lower 8 bits of: 0-2047
def RegFrequency1 EQU $c301 ; Upper 3 bits of: 0-2047

def RegFrequency1000s EQU $c310
def RegFrequency100s EQU $c311
def RegFrequency10s EQU $c312
def RegFrequency1s EQU $c313

def LimitBase EQU $c210
def LimitSweepPeriod EQU $c210
def LimitNegate EQU $c211
def LimitShift EQU $c212
def LimitDuty EQU $c213
def LimitLength EQU $c214
def LimitInitVolume EQU $c215
def LimitEnvelope EQU $c216
def LimitPeriod EQU $c217
def LimitFrequency EQU $c218
def LimitLengthEnable EQU $c219

charmap "0", $37
charmap "1", $38
charmap "2", $39
charmap "3", $3a
charmap "4", $3b
charmap "5", $3c
charmap "6", $3d
charmap "7", $3e
charmap "8", $3f
charmap "9", $40

; Return of address of lower tile map index.
; Args: register to be loaded with address, x coordinate, y coordinate
MACRO TilemapLow
    ld \1, $9800 + \3 * 32 + \2
ENDM

SECTION "ROM Bank 0 $100", ROM0[$100]

Entry::
  nop
  jp Start

; See: https://gbdev.gg8.se/wiki/articles/The_Cartridge_Header
 HeaderLogo::
  db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
  db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
  db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
  db "NOISE TEST", $00, $00, $00, $00, $00, $00

HeaderNewLicenseeCode::
  db $00, $00

HeaderSGBFlag::
  db $00

HeaderCartridgeType::
  db $00

HeaderROMSize::
  db $00

HeaderRAMSize::
  db $00

HeaderDestinationCode::
  db $01

HeaderOldLicenseeCode::
  db $00

HeaderMaskROMVersion::
  db $00

SECTION "ROM Bank 0 $500", ROM0[$500]
Start::
  ld a, %10001111
  ldh [rAUDENA], a            ; Turn on sound.
  ld a, $ff
  ldh [rAUDVOL], a            ; Full volume, both channels on.
  ldh [rAUDTERM], a           ; All sounds to all terminals.

  xor a
  ld [JoyPadData], a
  ld [JoyPadNewPresses], a
  ld [CursorIndex], a
  ld [PresetIndex], a
  ld [FastScrollTimer], a
  ld [RegSweepPeriod], a
  ld [RegNegate], a
  ld [RegShift], a
  ld [RegDuty], a
  ld [RegLength], a
  ld [RegInitVolume], a
  ld [RegEnvelope], a
  ld [RegPeriod], a
  ld [RegFrequency0], a
  ld [RegFrequency1], a
  ld [RegLengthEnable], a
  ld [RegFrequency1000s], a
  ld [RegFrequency100s], a
  ld [RegFrequency10s], a
  ld [RegFrequency1s], a

  ld a, 2
  ld [LimitEnvelope], a
  ld [LimitNegate], a
  ld [LimitLengthEnable], a
  ld a, 4
  ld [LimitDuty], a
  ld a, 8
  ld [LimitPeriod], a
  ld [LimitShift], a
  ld [LimitSweepPeriod], a
  ld a, 16
  ld [LimitInitVolume], a
  ld a, 64
  ld [LimitLength], a

  call TurnOffLcdc
  call InitTileMap
  ld a, %11100100
  ldh [rBGP], a
  ld a, SIZE_FONT_DATA
  ld hl, FontData
  ld de, FontDataVram
  call CopyTilesToVram
  ld hl, NoiseTestLogoData
  ld de, LogoDataVram
  ld a, SIZE_LOGO_DATA
  call CopyTilesToVram
  ld hl, $9800
  ld a, $30
  ld c, 4
  ld d, 0
  ld e, 12
: ld b, 20
: ld [hl+], a
  inc a
  dec b
  jr nz, :-
  add hl, de
  dec c
  jr nz, :--
  call DrawRegisters
  call TurnOnLcdc
  call RedrawScreen

.Loop:
  call ReadJoyPad
  ld hl, JoyPadNewPresses
  ld a, [JoyPadData]
  or a
  jr z, .ResetFastScroll
  ld a, [FastScrollTimer]
  inc a
  ld [FastScrollTimer], a
  cp 240
  jr c, .SkipFastScrollReset
  dec a
  ld [FastScrollTimer], a
  ld hl, JoyPadData
  jr .SkipFastScrollReset
.ResetFastScroll:
  xor a
  ld [FastScrollTimer], a
.SkipFastScrollReset:
  ld a, [hl]
  push hl
  ld b, MASK_BUTTON_DOWN
  and b
  call nz, PressedDownButton

  pop hl
  ld a, [hl]
  push hl
  ld b, MASK_BUTTON_UP
  and b
  call nz, PressedUpButton

  pop hl
  ld a, [hl]
  push hl
  ld b, MASK_BUTTON_RIGHT
  and b
  call nz, PressedRightButton

  pop hl
  ld a, [hl]
  push hl
  ld b, MASK_BUTTON_LEFT
  and b
  call nz, PressedLeftButton

  pop hl
  ld a, [hl]
  push hl
  ld b, MASK_BUTTON_A
  and b
  call nz, PressedAButton

  pop hl
  ld a, [hl]
  ld b, MASK_BUTTON_SELECT
  and b
  call nz, PressedSelectButton

  ld a, 255
  ld b, 2
.Wait
  dec a
  jr nz, .Wait
  ld a, 255
  dec b
  jr nz, .Wait

  jp .Loop

DrawRegisters::
  TilemapLow de, REG_X_ALIGN, Y_ALIGN
  ld hl, SweepPeriodString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 1)
  ld hl, NegateString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 2)
  ld hl, ShiftString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 3)
  ld hl, DutyString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 4)
  ld hl, LengthString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 5)
  ld hl, InitVolumeString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 6)
  ld hl, EnvelopeModeString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 7)
  ld hl, EnvelopePeriodString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 8)
  ld hl, FrequencyString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 9)
  ld hl, LengthEnableString
  call DrawString

  TilemapLow de, REG_X_ALIGN, (Y_ALIGN + 10)
  ld hl, PlayString
  call DrawString

  ret

RedrawScreen:
: ldh a, [rLY]                ; Wait for V-blank perio.d
  cp 144
  jr nz, :-

  ld hl, $98a1
  ld b, NUM_OPTS
: ld a, $2f
  ld [hl], a
  ld de, $20
  add hl, de
  dec b
  ld a, b
  or a
  jr nz, :-

  TilemapLow de, 7, 16
  ld hl, PresetString
  call DrawString
  ld a, [PresetIndex]
  ld [de], a

  TilemapLow hl, VALUE_X_ALIGN, Y_ALIGN
  ld a, [RegSweepPeriod]
  call BinToBcd6Bit
  ld [hl], a

  TilemapLow hl, VALUE_X_ALIGN, (Y_ALIGN + 1)
  ld a, [RegNegate]
  call BinToBcd6Bit
  ld [hl], a

  TilemapLow hl, VALUE_X_ALIGN, (Y_ALIGN + 2)
  ld a, [RegShift]
  call BinToBcd6Bit
  ld [hl], a

  TilemapLow de, VALUE_X_ALIGN, (Y_ALIGN + 3)
  ld a, [RegDuty]
  call BinToBcd6Bit
  ld [de], a

  TilemapLow hl, VALUE_X_ALIGN, (Y_ALIGN + 4)
  ld a, [RegLength]
  call BinToBcd6Bit
  ld c, a
  and a, $0f
  ld [hl-], a
  ld a, c
  swap a
  and a, $0f
  ld [hl], a

  TilemapLow hl, VALUE_X_ALIGN, (Y_ALIGN + 5)
  ld a, [RegInitVolume]
  call BinToBcd6Bit
  ld c, a
  and a, $0f
  ld [hl-], a
  ld a, c
  swap a
  and a, $0f
  ld [hl], a

  TilemapLow de, VALUE_X_ALIGN, (Y_ALIGN + 6)
  ld a, [RegEnvelope]
  call BinToBcd6Bit
  ld [de], a

  TilemapLow de, VALUE_X_ALIGN, (Y_ALIGN + 7)
  ld a, [RegPeriod]
  call BinToBcd6Bit
  ld [de], a


  ld a, [RegFrequency0]
  ld c, a
  ld a, [RegFrequency1]
  ld b, a
  call BinToBcd13Bit
  TilemapLow hl, VALUE_X_ALIGN, (Y_ALIGN + 8)
  ld a, e
  and $0f
  ld [hl-], a

  ld a, e
  swap a
  and $0f
  ld [hl-], a

  ld a, d
  and $0f
  ld [hl-], a

  ld a, d
  swap a
  and $0f
  ld [hl], a

  TilemapLow de, VALUE_X_ALIGN, (Y_ALIGN + 9)
  ld a, [RegLengthEnable]
  call BinToBcd6Bit
  ld [de], a

  ld a, [CursorIndex]
  add a, Y_ALIGN
  ld d, a
  ld c, REG_X_ALIGN - 1
  call TileMapLowFunc
  ld a, POINTER_INDEX
  ld [bc], a
  ret

; Select next lower option.
PressedDownButton::
  ld a, [CursorIndex]
  ld b, a
  sub a, NUM_OPTS - 1
  jr nz, :+
  ld b, -1
: inc b
  ld a, b
  ld [CursorIndex], a
  call RedrawScreen
  ret

; Select next upper option.
PressedUpButton::
  ld a, [CursorIndex]
  or a
  jr nz, :+
  ld a, NUM_OPTS
: dec a
  ld [CursorIndex], a
  call RedrawScreen
  ret

; Increase value of currently selected option.
PressedRightButton::
  ld a, [CursorIndex]
  ld d, 0
  cp 8
  jr nz, .SkipFrequencyReg
  ld a, [RegFrequency0]
  ld e, a
  ld a, [RegFrequency1]
  ld d, a
  inc de
  ld a, d
  cp 8
  jr nz, :+
  xor a
  ld e, 0
: ld [RegFrequency1], a
  ld a, e
  ld [RegFrequency0], a
  jr .UpdateScreenAndRegs
.SkipFrequencyReg:
  ld e, a
  ld hl, RegBase
  add hl, de
  ld a, [hl]
  push hl
  inc a
  ld b, a
  ld hl, LimitBase
  add hl, de
  ld a, [hl]
  cp b
  jr nz, :+
  ld b, 0
: ld a, b
  pop hl
  ld [hl], a
.UpdateScreenAndRegs:
  call RedrawScreen
  call ValueToReg
  ret

; Decrease value of currently selected option.
PressedLeftButton::
  ld a, [CursorIndex]
  cp 8
  jr nz, .SkipFrequencyReg
  ld a, [RegFrequency0]
  ld e, a
  ld a, [RegFrequency1]
  ld d, a
  or a
  jr nz, .UpdateFrequency
  ld a, e
  or a
  jr nz, .UpdateFrequency
  ld a, $ff
  ld [RegFrequency0], a
  ld a, $07
  ld [RegFrequency1], a
  jr .UpdateScreenAndRegs
.UpdateFrequency:
  dec de
  ld a, d
  ld [RegFrequency1], a
  ld a, e
  ld [RegFrequency0], a
  jr .UpdateScreenAndRegs
.SkipFrequencyReg:
  ld d, 0
  ld e, a
  ld hl, RegBase
  add hl, de
  ld a, [hl]
  push hl
  cp 0
  jr nz, :+
  ld b, a
  ld hl, LimitBase
  add hl, de
  ld a, [hl]
: dec a
  pop hl
  ld [hl], a
.UpdateScreenAndRegs:
  call RedrawScreen
  call ValueToReg
  ret

; If "PLAY" is currently selected, the sound registers are updated and the noise channel is triggered.
PressedAButton::
  call RedrawScreen
  ld a, [CursorIndex]
  cp NUM_OPTS - 1
  ret nz

  ld a, [RegShift]
  ld b, a
  ld a, [RegNegate]
  sla a
  sla a
  sla a
  or b
  ld b, a
  ld a, [RegSweepPeriod]
  swap a
  or b
  ldh [rNR10], a

  ld a, [RegLength]
  ld b, a
  ld a, [RegDuty]
  rrca
  rrca
  or b
  ldh [rNR11], a

  ld a, [RegPeriod]
  ld b, a
  ld a, [RegEnvelope]
  sla a
  sla a
  sla a
  or b
  ld b, a
  ld a, [RegInitVolume]
  swap a
  or b
  ldh [rNR12], a

  ld a, [RegFrequency0]
  ldh [rNR13], a

  ld a, [RegLengthEnable]
  sla a
  sla a
  or %1000
  swap a
  ld b, a
  ld a, [RegFrequency1]
  or b
  ldh [rNR14], a

  ret

; Update all sound registers according to the new preset.
PressedSelectButton:
  ld a, [PresetIndex]
  inc a
  cp NUM_PRESETS
  jr nz, :+
  ld a, 0
: ld [PresetIndex], a
  ld hl, PresetPtrs
  ld b, 0
  add a
  ld c, a
  add hl, bc
  ld a, [hl+]
  ld c, a
  ld a, [hl]
  ld b, a
  ld h, b
  ld l, c
  ld a, [hl+]
  ld [RegSweepPeriod], a
  ld a, [hl+]
  ld [RegNegate], a
  ld a, [hl+]
  ld [RegShift], a
  ld a, [hl+]
  ld [RegDuty], a
  ld a, [hl+]
  ld [RegLength], a
  ld a, [hl+]
  ld [RegInitVolume], a
  ld a, [hl+]
  ld [RegEnvelope], a
  ld a, [hl+]
  ld [RegPeriod], a
  ld a, [hl+]
  ld [RegFrequency0], a
  ld a, [hl+]
  ld [RegFrequency1], a
  ld a, [hl+]
  ld [RegLengthEnable], a
  call RedrawScreen
  ret

; Updates currently changed sound register except for length enable and trigger.
ValueToReg::
  ; TODO
  ret
;   ld a, [CursorIndex]
;   cp 0
;   jr nz, :+
;   ld a, [RegLength]
;   ldh [rNR41], a
;   ret
; : cp 4
;   jr nc, :+
;   ld a, [RegInitVolume]
;   swap a
;   ld b, a
;   ld a, [RegEnvelopeMode]
;   sla a
;   sla a
;   sla a
;   or b
;   ld b, a
;   ld a, [RegEnvelopePeriod]
;   or b
;   ldh [rNR42], a
;   ret
; : cp 7
;   jr nc, :+
;   ld a, [RegClockShift]
;   swap a
;   ld b, a
;   ld a, [RegLfsrWidth]
;   sla a
;   sla a
;   sla a
;   or b
;   ld b, a
;   ld a, [RegDivisor]
;   or b
;   ldh [rNR43], a
; : ret

; Like TileMapLow but as a function. X coord in "c", Y coord in "d". Result in "bc"
TileMapLowFunc::
  ld b, $98
  ld a, 5
.Loop:
  sla d
  jr nc, .SkipCarry
  inc b
.SkipCarry:
  dec a
  jr nz, .Loop
  ld a, d
  add a, c
jr nc, .SkipCarry2
  inc b
.SkipCarry2:
  ld c, a
  ret

; String address has to be in "hl". Tile map pointer in "de".
DrawString::
  ld b, CHAR_OFFSET
  ld a, [hl+]
  or a
  ret z
  sub a, b
  ld [de], a
  inc de
  jr DrawString

; Copies "a" tiles (each 16 byte) from [hl] to [de] with respect to the OAM flag.
CopyTilesToVram::
.Loop:
  push af
  ld a, 16
  call CopyBytesToVram
  pop af
  dec a
  jr nz, .Loop
  ret

; Copies "a" byte from [hl] to [de] with respect to the OAM flag.
CopyBytesToVram::
  ld b, STATF_OAM
.Loop:
  or a
  ret z
  ld c, a
: ldh a, [rSTAT]
  and b
  jr nz, :-                       ; Wait for OAM.
  ld a, [hl+]
  ld [de], a
  ld a, c
  inc de
  dec a
  jr .Loop

; $b2: Read joy pad and save result in JoyPadData and JoyNewPressess.
; From MSB to LSB: down, up, left, right, start, select, B, A.
ReadJoyPad:
  ld a, $20
  ldh [rP1], a              ; Select direction keys.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Read keys.
  cpl                       ; Invert, so a button press becomes 1.
  and $0f                   ; Select lower 4 bits.
  swap a
  ld b, a                   ; Direction key buttons now in upper nibble of b.
  ld a, $10
  ldh [rP1], a              ; Select button keys.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Wait.
  ldh a, [rP1]              ; Read keys.
  cpl                       ; Same procedure as before...
  and $0f
  or b                      ; Button keys now in lower nibble of a.
  ld c, a
  ld a, [JoyPadData]        ; Read old joy pad data.
  xor c                     ; Get changes from old to new.
  and c                     ; Only keep new buttons pressed.
  ld [JoyPadNewPresses], a  ; Save new joy pad data.
  ld a, c
  ld [JoyPadData], a        ; Save newly pressed buttons.
  ld a, $30
  ldh [rP1], a              ; Disable selection.
  ret

; Input in "a". Result in "a". Maximum of 6 bits.
BinToBcd6Bit:
  and $3f
  ld c, a
  ld b, 0
.LoopSubtractTen:
  cp 10
  jr c, .Done
  sub 10
  inc b
  jr .LoopSubtractTen
.Done:
  swap b
  add b
  ret

; Binary number in "bc". Result in "de". Maximum of 6 bits.
BinToBcd11Bit:
  xor a
  ld d, a
  ld e, a
.Loop
  ; Check if bc is zero. Return if true
  ld a, b
  or a
  jr nz, :+
  ld a, c
  or a
  ret z
: nop

  ld a, e
  inc a
  daa
  ld e, a
  jr nc, :+
  ; Carry case
  add a, 0
  ld a, d
  inc a
  daa
  ld d, a
: dec bc
  jr .Loop

; Add "de" to "bc"
Add16Bit::
  ld a, c
  add e
  ld c, a
  ld a, b
  adc d
  ret

; Subtract "de" from "bc"
Sub16Bit::
  ld a, c
  sub e
  ld c, a
  ld a, b
  sbc d
  ld b, a
  ret

; Compare "de" to "bc" ("de" - "bc")
Cp16Bit::
  push de
  push bc
  ld a, c
  sub e
  ld c, a
  ld a, b
  sbc d
  pop bc
  pop de
  ret

; Binary number in "bc". Result in "de". Maximum of 12 bits.
BinToBcd13Bit:
  xor a
  ld [RegFrequency1s], a
  ld [RegFrequency10s], a
  ld [RegFrequency100s], a
  ld [RegFrequency1000s], a
  ld a, $03
  ld d, a
  ld a, $e8
  ld e, a       ; de = 1000
.Loop1000:
  call Cp16Bit
  jr c, .Done1000
  ld hl, RegFrequency1000s
  inc [hl]
  call Sub16Bit
  jr .Loop1000

.Done1000:
  ld a, 0
  ld d, a
  ld a, 100
  ld e, a       ; de = 100
.Loop100:
  call Cp16Bit
  jr c, .Done100
  ld hl, RegFrequency100s
  inc [hl]
  call Sub16Bit
  jr .Loop100

.Done100:
  ld a, 0
  ld d, a
  ld a, 10
  ld e, a       ; de = 10
.Loop10:
  call Cp16Bit
  jr c, .Done10
  ld hl, RegFrequency10s
  inc [hl]
  call Sub16Bit
  jr .Loop10

.Done10:
  ld a, c
  ld e, a
  ld [RegFrequency1s], a
  ld a, [RegFrequency10s]
  swap a
  or e
  ld e, a
  ld a, [RegFrequency100s]
  ld d, a
  ld a, [RegFrequency1000s]
  swap a
  or d
  ld d, a
  ret

TurnOffLcdc::
  ld a, [rLCDC]
  ld b, %01111111
  and a, b
  ld [rLCDC], a
  ret

TurnOnLcdc::
  ld a, [rLCDC]
  ld b, %10000000
  or a, b
  ld [rLCDC], a
  ret

InitTileMap::
  ld hl, $9800
: ld a, $2f
  ld [hl+], a
  ld a, h
  cp $9c
  jr nz, :-
  ret

FontData::
  INCBIN "font.2bpp"

NoiseTestLogoData::
  INCBIN "square_test_logo.2bpp"

NoiseString::
  db "NOISE",0

SquareString::
  db "SQUARE",0

NegateString::
  db "NEGATE",0

SweepPeriodString::
  db "PERIOD SWEEP",0

ShiftString::
  db "SHIFT",0

DutyString::
  db "DUTY",0

LengthString::
  db "LENGTH",0

InitVolumeString::
  db "INIT VOLUME",0

EnvelopeModeString::
  db "ENVELOPE",0

EnvelopePeriodString::
  db "PERIOD ENV", 0

LengthEnableString::
  db "LENGTH ENABLE",0

FrequencyString::
  db "FREQUENCY",0

PlayString::
  db "PLAY",0

PresetString::
  db "PRESET",0

PresetPtrs:
  dw Preset0
  dw Preset1
  dw Preset2
  dw Preset3
  dw Preset4
  dw Preset5
  dw Preset6
  dw Preset7
  dw Preset8
  dw Preset9

; Empty pre
Preset0::
  db 0 ; sweep period
  db 0 ; negate
  db 0 ; shift
  db 0 ; duty
  db 0 ; length
  db 0 ; init volume
  db 0 ; envelope mode
  db 0 ; period
  db 0 ; frequency0
  db 0 ; frequency1
  db 0 ; length enable

; Simple sound at ~440Hz.
Preset1::
  db 0   ; sweep period
  db 0   ; negate
  db 0   ; shift
  db 2   ; duty
  db 0   ; length
  db 15  ; init volume
  db 0   ; envelope mode
  db 0   ; period
  db $d7 ; frequency0
  db $06 ; frequency1
  db 1   ; length enable

; Another simple sound at 440Hz fading in.
Preset2::
  db 0   ; sweep period
  db 0   ; negate
  db 0   ; shift
  db 0   ; duty
  db 0   ; length
  db 1   ; init volume
  db 1   ; envelope mode
  db 1   ; period
  db $d7 ; frequency0
  db $06 ; frequency1
  db 1   ; length enable

; Game Boy Boot C6
Preset3::
  db 0   ; sweep period
  db 0   ; negate
  db 0   ; shift
  db 2   ; duty
  db 0   ; length
  db 15  ; init volume
  db 0   ; envelope mode
  db 3   ; period
  db $83 ; frequency0
  db $07 ; frequency1
  db 0   ; length enable

; Game Boy Boot C7
Preset4::
  db 0   ; sweep period
  db 0   ; negate
  db 0   ; shift
  db 2   ; duty
  db 0   ; length
  db 15  ; init volume
  db 0   ; envelope mode
  db 3   ; period
  db $c1 ; frequency0
  db $07 ; frequency1
  db 0   ; length enable

; Sweep up.
Preset5::
  db 2   ; sweep period
  db 0   ; negate
  db 7   ; shift
  db 1   ; duty
  db 0   ; length
  db 15  ; init volume
  db 0   ; envelope mode
  db 3   ; period
  db $38 ; frequency0
  db $04 ; frequency1
  db 0   ; length enable

; Sweep down.
Preset6::
  db 2   ; sweep period
  db 1   ; negate
  db 7   ; shift
  db 1   ; duty
  db 0   ; length
  db 15  ; init volume
  db 0   ; envelope mode
  db 3   ; period
  db $ff ; frequency0
  db $07 ; frequency1
  db 0   ; length enable

; Super Mario Land Goomba hop.
; 0101 0111
; 1000 0000
; 0110 0010
; 0000 0110
; 1000 0111
Preset7::
  db 5   ; sweep period
  db 0   ; negate
  db 7   ; shift
  db 2   ; duty
  db 0   ; length
  db 6   ; init volume
  db 0   ; envelope mode
  db 2   ; period
  db $06 ; frequency0
  db $07 ; frequency1
  db 0   ; length enable

; Super Mario Land shroom taken.
; 0010 0111
; 1000 0000
; 0110 0010
; 0111 0010
; 1000 0110
Preset8::
  db 2   ; sweep period
  db 0   ; negate
  db 7   ; shift
  db 2   ; duty
  db 0   ; length
  db 6   ; init volume
  db 0   ; envelope mode
  db 2   ; period
  db $72 ; frequency0
  db $06 ; frequency1
  db 0   ; length enable

; Pokémon Red/Blue intro.
; 0010 0110
; 1100 1001
; 1011 0001
; 1010 1101
; 1000 0101
Preset9::
  db 2   ; sweep period
  db 0   ; negate
  db 6   ; shift
  db 3   ; duty
  db 9   ; length
  db 11  ; init volume
  db 0   ; envelope mode
  db 1   ; period
  db $ad ; frequency0
  db $05 ; frequency1
  db 0   ; length enable
