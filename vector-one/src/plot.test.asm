
	.MODULE test_plot 

	call vec1_cls

	ld b, 200
_demo1
	push bc
	ld b, 200
	call _random_plot
	call vec1_copy
	pop bc
	djnz _demo1
	ret

_random_plot
	push bc
	call _random_byte
	ld b, a
	call _random_byte	
	and 127
	ld c, a
	call vec1_plot
	pop bc
	djnz _random_plot
	ret



_random_byte
	ld a, r
	ld hl, (_random_byte1)
	xor (hl)
	inc hl
	bit 3, h
	jr z, _random_byte2
	ld hl, 0
_random_byte2
	ld (_random_byte1), hl
	ret

_random_byte1
	.WORD 0		