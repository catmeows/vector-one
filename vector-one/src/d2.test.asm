	.MODULE d2_test







_loop
	ld a, (_angle)		;update angle
	inc a
	and 63
	ld (_angle), a

	call d2_setrotation

	ld hl, (_x01)
	ld de, (_y01)
	
	call d2_rotation
		
	ld (_x11), hl
	ld (_y11), de

	ld hl, (_x11)
	ld de, 127
	call math1_plus
	ld a, l
	ld (_x), a	

	ld hl, (_y11)
	ld de, 63
	call math1_plus
	ld a, l
	ld (_y), a

	call vec1_cls

	ld a, (_x)
	ld b, a
	ld a, (_y)
	ld c, a 	

	ld d, 127
	ld e, 63	

	call vec1_line
	
	call vec1_copy

	jp _loop	


_angle	.BYTE 0

_x01	.WORD 50
_y01	.WORD 0

_x11	.WORD 0
_y11	.WORD 0

_x	.BYTE 0
_y	.BYTE 0