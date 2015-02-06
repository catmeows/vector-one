
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

	AT(0,1)

	AT(c,0)

	AT(d,e)

	ECHO(0,0)

	ECHO(c,0)

	ECHO(b,c)

	