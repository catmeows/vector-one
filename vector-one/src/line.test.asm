

	.MODULE test_line

	call vec1_cls
	ld b, 128
	ld c, 16
	ld d, 150
	ld e, 99
	call vec1_line
	call vec1_copy
	ret