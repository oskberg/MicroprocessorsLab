	#include <xc.inc>

psect	code, abs

sDelay	EQU	0x10
sdCount	EQU	0x20
	
OE1	EQU	1
OE2	EQU	2
CP1	EQU	5
CP2	EQU	6


main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
	 
; a few hundred nanoseconds delay
shortDelay:
	movlw	sDelay
	movwf	sdCount, A	;store short delay time in sdCount
sdLoop:	decfsz	sdCount, A
	bra	sdLoop
	return
	
setup:	; set controlling bits to high
	setf	TRISE, A
	clrf	TRISD, A
	
	banksel	PADCFG1	    ; change bank
	bsf	REPU	    ; set pullups
	movlb	0x00	    ; change bank back
	
	BSF	PORTD, OE1, A
	BSF	PORTD, OE2, A
	BSF	PORTD, CP1, A
	BSF	PORTD, CP2, A
	
	return	0
	
; Simple write test without connected memory
writeTest1:
	clrf	TRISE, A
	movlw	0xbb		; set d values here
	movwf	LATE, A
	
	BCF	PORTD, CP1, A	;Set clock low
	call	shortDelay	;delay for a little bit
	BSF	PORTD, CP1, A	;set high again	
	
	setf	TRISE, A
	return
	
; simple read function without connected memory
readTest1:
	BCF	PORTD, OE1, A	;set oe1 low to read the output
	call	shortDelay
	movf	PORTE, W, A	;move output into wreg
	BSF	PORTD, OE1, A	
	return	0
start:
	call	setup
	call	shortDelay
	call	shortDelay
	call	writeTest1
	call	shortDelay
	call	shortDelay
	call	readTest1
	
	goto	main