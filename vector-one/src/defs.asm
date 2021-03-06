

#DEFINE	add_hl_a	add a, l \ ld l, a \ jr nc, $+3 \ inc h
			;HL=HL+A  
			;Z=* CY=?

#DEFINE	add_de_a	add a, e \ ld e, a \ jr nc, $+3 \ inc d
			;DE=DE+A  
			;Z=* CY=?

#DEFINE withix		.BYTE 221	
			;opcode prefix for IX

#DEFINE withiy		.BYTE 253	
			;opcode prefix for IY

#DEFINE swap(x,y)	push af \ ld a, x \ ld x, y \ ld y, a \ pop af
			;swap registers 
			;cannot swap A

#DEFINE swapx(x,y)	.BYTE 221 \ ld l, x \ ld x, y \ .BYTE 221 \ ld y, l
			;swap registers through LX  
			;bit faster 
			;can swap A 
			;cannot swap L, H 
#DEFINE case(x,table)	ld a, x \ add a, a \ ld hl, table \  add_hl_a \ ld a, (hl)
#DEFCONT		\ inc hl \ ld h, (hl) \ ld l, a \ jp (hl)
			;jump to A-th label in TABLE
			; A H L destroyed
			;CY=? Z=0

#DEFINE TODO		ret
			;empty subroutine

#DEFINE AT(x,y)		ld a, 22 \ rst 10 \ ld a, y \ rst 10 \ ld a, x \ rst 10 \	
			;literally "print at x,y;"

#DEFINE ECHO(char,ofs)	ld a, char \ add a, ofs \ rst 10 \
			;print ascii code (char+ofs)

#DEFINE ex_de_bc	push de \ ld d, b \ ld e, c \ pop bc \
			;swap registers BC and DE


