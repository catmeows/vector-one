
	.MODULE math_9b

	;neg
	;plus 
	;minus
	;mul

math1_neg
	;HL=-HL
	ld a, h
	xor 1
	ld h, a
	ret

math1_minus
	;HL=HL-DE
	ld a, d
	xor 1
	ld d, a

math1_plus
	;HL=HL+DE
	ld a, h
	xor d
	jr nz, _sub
	ld a, l
	add a, e
	ld l, a
	ret

_sub
	ld a, l
	cp e
	jr nc, _sub1 
	ex de, hl
_sub1
	ld a, l
	sub e
	ld l, a
	ret

math1_mul
	;HLA=HL*DE
	ld a, h		;sign=sign1 xor sign2
	xor d
	ld c, a

	ld h, l
	ld d, 0
	ld l, d	

	add hl, hl
	jr nc, _mul1
	add hl, de
_mul1
	add hl, hl
	jr nc, _mul2
	add hl, de
_mul2
	add hl, hl
	jr nc, _mul3
	add hl, de
_mul3
	add hl, hl
	jr nc, _mul4
	add hl, de
_mul4
	add hl, hl
	jr nc, _mul5
	add hl, de
_mul5
	add hl, hl
	jr nc, _mul6
	add hl, de
_mul6
	add hl, hl
	jr nc, _mul7
	add hl, de
_mul7
	add hl, hl
	jr nc, _mul8
	add hl, de
_mul8
	ld a, l
	ld l, h
	ld h, c
	ret

math1_cos
	;HL=cos(A)
	ld hl, _costab
	jr _sin1
math1_sin
	;HL=sin(A)
	ld hl, _sintab
_sin1
	and 63
	add a, a
	add_hl_a
	ld l, (hl)
	inc hl
	ld h, (hl)
	ret

_sintab
	.BYTE   0, 0	;sin(0dg)
	.BYTE  25, 0	;sin(5.625dg)
	.BYTE  50, 0	
	.BYTE  74, 0	
	.BYTE  98, 0
	.BYTE 121, 0
	.BYTE 142, 0
	.BYTE 162, 0
	.BYTE 181, 0
	.BYTE 198, 0
	.BYTE 212, 0
	.BYTE 226, 0
	.BYTE 237, 0
	.BYTE 245, 0
	.BYTE 251, 0
	.BYTE 255, 0
_costab
	.BYTE 255, 0	;sin(90dg)==cos(0dg)
	.BYTE 255, 0
	.BYTE 251, 0
	.BYTE 245, 0
	.BYTE 237, 0
	.BYTE 226, 0
	.BYTE 212, 0
	.BYTE 198, 0
	.BYTE 181, 0
	.BYTE 162, 0
	.BYTE 142, 0
	.BYTE 121, 0
	.BYTE  98, 0
	.BYTE  74, 0
	.BYTE  50, 0
	.BYTE  25, 0

	.BYTE   0, 0	;sin(180dg)==cos(90dg)
	.BYTE  25, 1
	.BYTE  50, 1
	.BYTE  74, 1
	.BYTE  98, 1
	.BYTE 121, 1
	.BYTE 142, 1
	.BYTE 162, 1
	.BYTE 181, 1
	.BYTE 198, 1
	.BYTE 212, 1
	.BYTE 226, 1
	.BYTE 237, 1 
	.BYTE 245, 1
	.BYTE 251, 1
	.BYTE 255, 1

	.BYTE 255, 1	;sin(270dg)==cos(180dg)
	.BYTE 255, 1
	.BYTE 251, 1
	.BYTE 245, 1
	.BYTE 237, 1
	.BYTE 226, 1
	.BYTE 212, 1
	.BYTE 198, 1
	.BYTE 181, 1
	.BYTE 162, 1
	.BYTE 142, 1
	.BYTE 121, 1
	.BYTE  98, 1
	.BYTE  74, 1
	.BYTE  50, 1
	.BYTE  25, 1

	.BYTE   0, 0	
	.BYTE  25, 0	
	.BYTE  50, 0	
	.BYTE  74, 0	
	.BYTE  98, 0
	.BYTE 121, 0
	.BYTE 142, 0
	.BYTE 162, 0
	.BYTE 181, 0
	.BYTE 198, 0
	.BYTE 212, 0
	.BYTE 226, 0
	.BYTE 237, 0
	.BYTE 245, 0
	.BYTE 251, 0
	.BYTE 255, 0
	