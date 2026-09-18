
#define equ .EQU

userMem		equ 0D1A881h 
tExtTok		equ 0EFh
tAsm84CeCmp	equ 07Bh

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

_RunIndicOff	equ 0020848h
;_RunIndicOn	equ 0020844h
_RStrShadow	equ 0020854h
_DrawStatusBar	equ 0021A3Ch


; CONSTANTS
; ---------

BUFFER_LCD	equ 0D40000h
BUFFER_PALETTE	equ 0E30200h

LCD_WIDTH	equ 320
LCD_HEIGHT	equ 240
LCD_PIXELS	equ (LCD_WIDTH * LCD_HEIGHT)

BUFFER_TEMP	equ BUFFER_LCD + LCD_PIXELS

GOL_WIDTH	equ (LCD_WIDTH / 2)
GOL_HEIGHT	equ (LCD_HEIGHT / 2)
GOL_PIXELS	equ (GOL_WIDTH * GOL_HEIGHT)

BUFFER_GOL	equ BUFFER_TEMP + (GOL_WIDTH * 2)


;SOURCE CODE
;¯¯¯¯¯¯¯¯¯¯¯

	call _RunIndicOff

	call gfx_Begin

	ld hl, 0 ; black
	ld (BUFFER_PALETTE + (080h*2)), hl
	dec hl ; white
	ld (BUFFER_PALETTE + (000h*2)), hl
	ld hl, 0010100101001010b * 256 ; waiting color
	ld (BUFFER_PALETTE + (0FFh*2) - 1), hl


_rand:
	ld ix, BUFFER_GOL
	ld bc, GOL_PIXELS/256
_rand_loop:

	;Generate random number (from Axe)
	ld   a, r
	ld   d, a
	ld   e, (hl)
	add  hl, de
	ld   e, a
	add  hl, de

	ld   a, h
	xor  l

	and a, 080h
	ld (ix+0), a
	inc ix
	
	djnz _rand_loop
	dec c
	jr nz, _rand_loop


_step:
	ld hl, BUFFER_GOL
	ld de, GOL_WIDTH
	ld bc, GOL_PIXELS/256

_step_loop:
	ld a, (hl)
	inc hl
	and a, 080h
	jr z, _step_skip

	inc (hl) ;right

	sbc hl, de
	inc (hl) ;top-right
	dec hl
	inc (hl) ;top
	dec hl
	inc (hl) ;top-left

	add hl, de
	inc (hl) ;left

	add hl, de
	inc (hl) ;bottom-left
	inc hl
	inc (hl) ;bottom
	inc hl
	inc (hl) ;bottom-right

	sbc hl, de

_step_skip:
	djnz _step_loop
	dec c
	jr nz, _step_loop


	ld hl, BUFFER_GOL
	ld bc, GOL_PIXELS/256
_evol_loop:

	ld a, (hl)
	rlca
	sub a, 0101b
	cp 0111b-0101b+1
	ld a, d
	rra
	ld (hl), a
	inc hl

	djnz _evol_loop
	dec c
	jr nz, _evol_loop


_draw:
	ld hl, BUFFER_GOL
	ld de, BUFFER_LCD
	ld a, GOL_HEIGHT
_draw_col:
	ld bc, (GOL_WIDTH * 256) + LCD_WIDTH
	push de
_draw_row:
	ldi
	dec hl
	ldi
	djnz _draw_row
	ex (sp), hl
	ld bc, LCD_WIDTH
	ldir
	pop hl
	dec a
	jr nz, _draw_col


	call os_GetCSC
	cp skClear
	jr nz, _step


_exit:
	call gfx_End
	call _RStrShadow
	jp _DrawStatusBar


; INCLUDES
; --------

#include "clibs_graphx.asm"

os_GetCSC equ 021D3Ch
skClear	equ 0Fh
