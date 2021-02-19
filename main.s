	#include <xc.inc>

psect	code, abs
OE1	EQU	1
OE2	EQU	2
CP1	EQU	5
CP2	EQU	6

main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
	
	
	
setup:	; set controlling bits to high
	clrf	TRISD, A
	BSF	OE1, 1, A
	BSF	OE2, 1, A
	BSF	CP1, 1, A
	BSF	CP2, 1, A
	return	0
start:
	call	setup
	
	