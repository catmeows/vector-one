

	.MODULE test_line

	xor a
	ld ($5C78), a

	call vec1_cls	

	ld b, 123
	ld c, 4
	ld d, 38
	ld e, 112
_loop	
	push bc
	push de
	call vec1_line
	pop de
	pop bc
	ld a, 5
	add a, d
	ld d, a
	jr nc, _loop

	ld b, 64
	ld c, 11
	ld d, 144
	ld e, 126

_loop2
	push bc
	push de
	call vec1_line
	pop de
	pop bc
	ld a, 5
	add a, b
	ld b, a
	jr nc, _loop2

	call vec1_copy

	ld a, ($5C78)
	ld b, 0
	ld c, a
	ret
