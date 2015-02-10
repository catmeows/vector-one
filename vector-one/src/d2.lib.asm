


	.MODULE two_dim

	#DEFINE mA _d2_matrix
	#DEFINE mB _d2_matrix + 2
	#DEFINE mC _d2_matrix + 4
	#DEFINE mD _d2_matrix + 6
	


d2_setrotation
	;set matrix with A
	;  cos A , sin A
	; -sin A , cos A
	ld c, a
	call math1_cos
	ld (mA), hl
	ld (mD), hl
	ld a, c
	call math1_sin
	ld (mB), hl
	call math1_neg
	ld (mC), hl
	ret

d2_rotation
	;HL=x0
	;DE=y0
	;result HL=x1
	;       DE=y1
	;
	;x1 = |mA mB|* x0 
	;y1   |mC mD|  y0
	
	;x1 = mA * x0 + mB * y0

	push hl			; x0
	push de			; x0 y0
	push de			; x0 y0 y0
	ld de, (mA)		
	call math1_mul
	pop de			; x0 y0
	push hl			; x0 y0 mA*x0
	ld hl, (mB)		
	call math1_mul
	pop de			; x0 y0
	call math1_plus		
	pop de			; x0
	ex (sp), hl		; mA*x0+mB*y0
	push de			; mA*x0+mB*y0 y0	

	;y1 = mC * x0 + mD * y0

	ld de, (mC)
	call math1_mul
	pop de			; mA*x0+mB*y0
	push hl			; mA*x0+mB*y0 mC*x0
	ld hl, (mD)
	call math1_mul
	pop de			; mA*x0+mB*y0
	call math1_plus
	ex de, hl		; DE = y1
	pop hl			; HL = x1
	ret	

_d2_matrix
	.WORD 0, 0, 0, 0