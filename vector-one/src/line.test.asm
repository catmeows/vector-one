

	.MODULE test_line


	call vec1_cls	
	ld hl, 0
	ld b, 64
_loop
	push bc
	
	ld b, (hl)
	inc hl
	ld a, (hl)
	inc hl
	and 127
	ld c, a

	ld d, (hl)
	inc hl
	ld a, (hl)
	inc hl
	and 127
	ld e, a

	push hl

	call vec1_line
	pop hl
	pop bc
	djnz _loop
	
	call vec1_copy

	ret

