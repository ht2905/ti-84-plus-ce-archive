.assume ADL=1
#include "ti84pce.inc"

	.org	userMem - 2
	.db	tExtTok, tAsm84CeCmp

	ld	hl, 0E00005h
	ld	(hl), 1	; Set flash wait states to 5 + 1 = 6 (total access time = 7)
	set	3, (iy + 24h)	; Enable lower case, just for fun
	ret