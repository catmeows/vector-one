

	;vec1_buf 	pointer to pixel buffer

	;vec1_cls	clear buffer
	;vec1_clsf	fill buffer by byte
	
	;vec1_copy	copy buffer on the top of screen
	;vec1_cppyx	copy buffer to screen stating at DE (DE must be first byte of pixel line)

	;vec1_plot	put pixel with x-coord in B and y-coord in C

	.MODULE linelib

vec1_buf
	.BLOCK 4096
vec1_cls

	;CLEAR BUFFER

	xor a
vec1_clsf 
	ld b, 128
	ld hl, vec1_buf
_vec1_cls1
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l 
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l

	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l 
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l
	ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc l \ ld (hl), a \ inc hl
	djnz _vec1_cls1
	ret

vec1_copy

	;COPY BUFFER TO SCREEN 

	ld de, $4000
vec1_copyx
	ld hl, vec1_buf
	ld b, 128
_vec1_copy1
	ld c, h
	push de
	ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi
	ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi
	ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi
	ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi \ ldi
	pop de
	inc d
	ld a, d
	and 7
	jr nz, _vec1_copy2
	ld a, 32
	add a, e
	ld e, a
	jr c, _vec1_copy2
	ld a, d
	sub 8
	ld d, a
_vec1_copy2
	djnz _vec1_copy1
	ret

vec1_plot

      	;PLOT X,Y
	;B = x, C = y

	ld h, c
	xor a
	srl h
	rra
	srl h
	rra
	srl h
	rra
	ld l, a		;HL=((y<<8)>>3))==(y<<5)==y*32
	ld de, vec1_buf
	add hl, de

	;HL = begin 
	;CY = 0

	ld a, b
	rrca
	rrca
	rrca
	and 31
	add a, l
	ld l, a		;HL= y*32 + x>>3

	;opcode of set x, (hl) = 8*bit + op($c6) 

	ld a, b
	and %00000111
	add a, a
	add a, a
	add a, a
	neg		; 0,8,16,24,32,64,128 -> 0,-8,-16,-24,...
	add a, $FE	; -> $FE, $F6, $EE ...
	ld (_vec1_plot1), a	;modify code
	.BYTE $CB
_vec1_plot1
	nop	
	ret	
	 