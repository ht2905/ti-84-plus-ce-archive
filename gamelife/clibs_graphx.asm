; NOTE: I am NOT the author of the source code contained in this file.
; I've assembled here and slightly edited source code found elsewhere:
; - The equates were extracted from a "ti84pce.inc" file found online.
; - The assembly routines are taken from the "CE Programming" "graphx" library
;   (v8.8, released under GNU LGPL v3.0). The original code can be found there:
;   https://github.com/CE-Programming/toolchain/blob/v8.8/src/graphx/graphx.asm
;   https://github.com/CE-Programming/toolchain/blob/v8.8/license (its license)



; INCLUDES
; --------

;#include "ti84pce.inc"

VRAM			equ 0D40000h

_boot_ClearVRAM		equ 000374h

;pLcdRange		equ 04000h
mpLcdRange		equ 0E30000h

lcdTiming0		equ 0000h
;pLcdTiming0		equ pLcdRange + lcdTiming0
;mpLcdTiming0		equ mpLcdRange + lcdTiming0
;lcdTiming1		equ 0004h
;pLcdTiming1		equ pLcdRange + lcdTiming1
;mpLcdTiming1		equ mpLcdRange + lcdTiming1
;lcdTiming2		equ 0008h
;pLcdTiming2		equ pLcdRange + lcdTiming2
;mpLcdTiming2		equ mpLcdRange + lcdTiming2
;lcdTiming3		equ 000Ch
;pLcdTiming3		equ pLcdRange + lcdTiming3
;mpLcdTiming3		equ mpLcdRange + lcdTiming3

lcdBase			equ 0010h
;pLcdBase		equ pLcdRange + lcdBase
mpLcdBase		equ mpLcdRange + lcdBase
;lcdUpbase		equ 0010h
;pLcdUpbase		equ pLcdRange + lcdUpbase
;mpLcdUpbase		equ mpLcdRange + lcdUpbase
lcdLpbase		equ 0014h
;pLcdLpbase		equ pLcdRange + lcdLpbase
mpLcdLpbase		equ mpLcdRange + lcdLpbase

lcdCtrl			equ 0018h
;pLcdCtrl		equ pLcdRange + lcdCtrl
;mpLcdCtrl		equ mpLcdRange + lcdCtrl
lcdEn			equ 01h
lcdTft			equ 20h
;lcdBpp1			equ 0000b + lcdTft + lcdEn
;lcdBpp2			equ 0010b + lcdTft + lcdEn
;lcdBpp4			equ 0100b + lcdTft + lcdEn
lcdBpp8			equ 0110b + lcdTft + lcdEn
;lcdBpp16Alt		equ 1000b + lcdTft + lcdEn
;lcdBpp24		equ 1010b + lcdTft + lcdEn
lcdBpp16		equ 1100b + lcdTft + lcdEn
;lcdBpp12		equ 1110b + lcdTft + lcdEn
lcdBgr			equ 100h
;lcdBigEndian		equ 200h
;lcdBigEndianPixels	equ 400h
lcdPwr			equ 800h
;lcdIntVSync		equ 0000h
;lcdIntBack		equ 1000h
;lcdIntActiveVideo	equ 2000h
lcdIntFront		equ 3000h
lcdWatermark		equ 10000h
lcdNormalMode		equ lcdPwr + lcdBgr + lcdBpp16


; CONSTANTS
; ---------

;LcdWidth		equ 320
;LcdHeight		equ 240
;LcdSize			equ LcdWidth*LcdHeight

CurrentBuffer		equ mpLcdLpbase


;SOURCE CODE
;¯¯¯¯¯¯¯¯¯¯¯

;-------------------------------------------------------------------------------
gfx_Begin:
; Sets up the graphics canvas
; Arguments:
;  arg0: bpp mode to start in
; Returns:
;  None
	call	_boot_ClearVRAM		; clear the screen
lcdGraphxMode equ lcdWatermark+lcdIntFront+lcdPwr+lcdBgr+lcdBpp8
	ld	de,lcdGraphxMode
	ld	hl,CurrentBuffer
SetGfx:
	ld	bc,VRAM
	ld	(hl),bc			; set the current draw to the screen
;assert CurrentBuffer and -$100 = mpLcdRange
	ld	l,lcdCtrl
	ld	(hl),de			; set lots of control parameters
	ld	l,lcdTiming0+1
	ld	de,_LcdTiming
;assert VRAM and $FF = 0
	ld	b,8+1			; +1 because c = 0, so first ldi will
					; decrement b
_ExchangeTimingLoop:			; exchange stored and active timing
	ld	a,(de)
	ldi
	dec	hl
	ld	(hl),a
	inc	hl
	djnz	_ExchangeTimingLoop
;;	jp	gfx_SetDefaultPalette	; setup the default palette
;;assert $ = gfx_SetDefaultPalette
	ret

;;-------------------------------------------------------------------------------
;gfx_SetDefaultPalette:
;; Sets up the default palette where H=L
;; Arguments:
;;  None
;; Returns:
;;  None
;	ld	de,mpLcdPalette		; address of mmio palette
;	ld	b,e			; b = 0
;gfx_SetDefaultPalette_loop:
;	ld	a,b
;	rrca
;	xor	a,b
;	and	a,224
;	xor	a,b
;	ld	(de),a
;	inc	de
;	ld	a,b
;	rla
;	rla
;	rla
;	ld	a,b
;	rra
;	ld	(de),a
;	inc	de
;	inc	b
;	jr	nz,gfx_SetDefaultPalette_loop		; loop for 256 times to fill palette
;	ret

;-------------------------------------------------------------------------------
gfx_End:
; Closes the graphics library and sets up for the TI-OS
; Arguments:
;  None
; Returns:
;  None
	call	_boot_ClearVRAM		; clear the screen
	ld	de,lcdNormalMode
	ld	hl,mpLcdBase
	jr	SetGfx			; restore the screen mode

_LcdTiming:
;	.db	14 * 4 ; 14 shl 2		; PPL shl 2
	.db	7			; HSW
	.db	87			; HFP
	.db	63			; HBP
	.dw	319 ; (0 shl 10)+319		; (VSW shl 10)+LPP
	.db	179			; VFP
	.db	0			; VBP
	.db	0 ; (0 shl 6)+(0 shl 5)+0	; (ACB shl 6)+(CLKSEL shl 5)+PCD_LO
;  H = ((PPL+1)*16)+(HSW+1)+(HFP+1)+(HBP+1) = 240+8+88+64 = 400
;  V = (LPP+1)+(VSW+1)+VFP+VBP = 320+1+179+0 = 500
; CC = H*V*PCD*2 = 400*500*2*2 = 800000
; Hz = 48000000/CC = 60

