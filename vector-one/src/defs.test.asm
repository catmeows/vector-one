
	.MODULE test_defs	
	
	add_hl_a		

	add_de_a

	withix
	ld a, l

	withiy
	ld a, l

	swap(b,b)

	swap(b,c)
	
	swap(b,e)
	
	swap(b,l)

	swapx(a,a)

	swapx(a,c)
	
	swapx(c,b)

	swapx(e,c)	

	case(b, _table)

	case(a, _table)
_table
	.WORD one, two, three, four
one
two
three
four

	
	