	.MODULE math_test

	;test neg 

	ld h, 0
	ld l, 1
	call math1_neg
	ld a, h
	cp 1
	jr nz, _test1
	ld a, l
	cp 1
	jr nz, _test1
	ld a, 32
	jr _test2
_test1
	ld a, 16
_test2
	ld (22528), a
	
	ld h, 1
	ld l, 253
	call math1_neg
	ld a, h
	cp 0
	jr nz, _test3
	ld a, l
	cp 253
	jr nz, _test3
	ld a, 32
	jr _test4
_test3
	ld a, 16
_test4
	ld (22529), a
	
	;test plus

	ld h, 0
	ld l, 36
	ld d, 0
	ld e, 44
	call math1_plus
	ld a, h
	or a
	jr nz, _test5
	ld a, l
	cp 80
	jr nz, _test5
	ld a, 32
	jr _test6
_test5
	ld a, 16
_test6
	ld (22530), a

	;test minus

	ld h, 0
	ld l, 44
	ld d, 0
	ld e, 36
	call math1_minus
	ld a, h
	or a
	jr nz, _test7
	ld a, l
	cp 8
	jr nz, _test7
	ld a, 32
	jr _test8
_test7
	ld a, 16
_test8
	ld (22531), a

	;test minus 2
	
	ld h, 1
	ld l, 44
	ld d, 0
	ld e, 36
	call math1_plus
	ld a, h
	cp 1
	jr nz, _test9
	ld a, l
	cp 8
	jr nz, _test9
	ld a, 32
	jr _testA
_test9
	ld a, 16
_testA
	ld (22532), a

	;test mul
	
	ld h, 0
	ld l, 12
	ld d, 0
	ld e, 4
	call math1_mul
	cp 48
	jr nz, _test_B
	ld a, l
	or a
	jr nz, _test_B
	ld a, h
	or a
	jr nz, _test_B
	ld a, 32
	jr _test_C
_test_B
	ld a, 16
_test_C
	ld (22533), a

	;test mul 2
	
	ld h, 1
	ld l, 36
	ld d, 0
	ld e, 8
	call math1_mul
	cp 32
	jr nz, _test_D
	ld a, l
	cp 1
	jr nz, _test_D
	ld a, h
	cp 1
	jr nz, _test_D
	ld a, 32
	jr _test_E
_test_D
	ld a, 16
_test_E
	ld (22534), a
	ret
 	

	