

	;vec1_buf 	pointer to pixel buffer

	;vec1_cls	clear buffer
	;vec1_clsf	fill buffer by byte
	
	;vec1_copy	copy buffer on the top of screen
	;vec1_cppyx	copy buffer to screen stating at DE (DE must be first byte of pixel line)

	;vec1_plot	put pixel with x-coord in B and y-coord in C

	.MODULE linelib

vec1_buf
	.FILL 4096
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


vec1_line	
	;draw line from x1,y1 to x2,y2
	;0<=x<=255 0<=y<128
	;B=x1 C=y1 D=x2 E=y2


	;check for special case x1==x2 or y1==y2. they use own code.

	ld a, b
	cp d
 	jp z, _line_vr
	ld a, c
	cp e
	jp z, _line_hz

	;compute dx = abs(x1 - x2), dy = abs(y1-y2)

#DEFINE absdelta(x,y)	ld a, x \ sub y \ jr nc, $ + 4 \ neg \;A = abs ( x - y )		
	
	absdelta(b,d)	;dx
	ld h, a
	absdelta(c,e)	;dy
	ld l, a

	;if (dx > dy)
	sub h
	jp c, _linex

	;line has main Y axis
	
		;check for zero length

		ld a, l
		or a
		jp z, vec1_plot		;fallback to plot

		withix
		ld l, a			;store dy, the loop count
		ld a, h
		withix
		ld h, a			;store dx

		;find left point
		ld a, b
		cp e
		jr c, _liney1		; if x1>=x2 swap points 
		ex_de_bc		
_liney1
		;decide vertical step
		
		ld a, c
		cp e
		ld de, 32
		jr c, _liney2
		ld de, -32		;vertical step in direction of second point
_liney2		
		;pointer of buffer(x,y) 

		call _line_start	;HL=ptr A=bit from left BC=x1y1 DE=vertical step
		
		;prepare initial jump inside loop
		
		ld b, h		;save HL
		ld c, l		
		add a, a	;compute entry point for given bit
		ld hl, _liney_jmptab
		add a, l
		ld l, a
		jr nc, $ + 3
		inc h						
		ld a, (hl)
		inc hl
		ld h, (hl)
		ld l, a			
		push hl		;store ptr on stack
		ld h, b
		ld l, c			

		;C=dx

		withix
		ld c, h

		;A=dy/2 B=dy		

		withix
		ld a, l
		ld b, a
		srl a

		;entry point

		ret


_liney_jmptab
		.WORD _liney_7a, _liney_6a, _liney_5a, _liney_4a   
		.WORD _liney_3a, _liney_2a, _liney_1a, _liney_0a
						
		
_liney_7
		withix
		add a, l 		;add dy 
		dec b			;decrement loop counter  
		ret z 
_liney_7a
		set 7, (hl) 		;put pixel
		add hl, de		;move by 1 up or down
		sub c			;sub dx		
		jr c, _liney_6		;move one pixel right
     		djnz _liney_7a		;loop
		ret
		
_liney_6
		withix \ add a, l \ dec b \ ret z \
_liney_6a
		set 6, (hl) \ add hl, de \ sub c \
		jr c, _liney_5
		djnz _liney_6a \ ret

	
_liney_5
		withix \ add a, l \ dec b \ ret z \
_liney_5a
		set 5, (hl) \ add hl, de \ sub c \
		jr c, _liney_4
		djnz _liney_5a \ ret

	
_liney_4
		withix \ add a, l \ dec b \ ret z \
_liney_4a
		set 4, (hl) \ add hl, de \ sub c \
		jr c, _liney_3
		djnz _liney_4a \ ret

	
_liney_3
		withix \ add a, l \ dec b \ ret z \
_liney_3a
		set 3, (hl) \ add hl, de \ sub c \
		jr c, _liney_2
		djnz _liney_3a \ ret

	
_liney_2
		withix \ add a, l \ dec b \ ret z \
_liney_2a
		set 2, (hl) \ add hl, de \ sub c \ 
		jr c, _liney_1
		djnz _liney_2a \ ret
	
_liney_1
		withix \ add a, l \ dec b \ ret z \
_liney_1a
		set 1, (hl) \ add hl, de \ sub c \ 
		jr c, _liney_0
		djnz _liney_1a \ ret


	
_liney_0
		withix \ add a, l \ dec b \ ret z \
_liney_0a
		set 0, (hl) \ add hl, de \ sub c \
		jr c, _liney_0b
		djnz _liney_0a \ ret

_liney_0b
		inc l
		jp _liney_7

_linex
	TODO ;line has main X axis

_line_vr
	TODO ;vertical line 

_line_hz
	TODO ;horizontal line
	
_line_start
	;B=x C=y
	;common part for x- and y- lines
	;HL = ptr to buffer(x,y)
	;A = bit in byte, from left side 	

	;HL = y * 32 + vec1_buf 
	
	ld h, c
	xor a
	srl h
	rra
	srl h
	rra
	srl h
	rra
	ld l, a
	push de		
	ld de, vec1_buf
	add hl, de
	pop de

	;HL = HL + x div 8

	ld a, b
	rrca
	rrca
	rrca
	and 31
	add a, l
	ld l, a		

	;A = x mod 8 

	ld a, b
	and 7
	ret



		