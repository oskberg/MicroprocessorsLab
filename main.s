	#include <xc.inc>

psect	code, abs

sDelay	EQU	0x10
sdCount	EQU	0x20
	
mem1	EQU	0x30
mem2	EQU	0x32
	
OE1	EQU	1
OE2	EQU	2
CP1	EQU	5
CP2	EQU	6


main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100

; perform a clock pulse on cp1
clockPulse1:
	BCF	PORTD, CP1, A	;Set clock low
	call	shortDelay	;delay for a little bit
	BSF	PORTD, CP1, A	;set high again	
	return

; perform a clock pulse on cp2
clockPulse2:
	BCF	PORTD, CP2, A	;Set clock low
	call	shortDelay	;delay for a little bit
	BSF	PORTD, CP2, A	;set high again	
	return

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
	
; Simple write
writeTest1:
	clrf	TRISE, A
	movlw	0xbc		; set E values here
	movwf	LATE, A
	
	call	clockPulse1
	
	setf	TRISE, A
	return
	
; Simple write
writeTest2:
	clrf	TRISE, A
	movlw	0x38		; set E values here
	movwf	LATE, A
	
	call	clockPulse2
	
	setf	TRISE, A
	return
	
; simple read function without connected memory
readTest1:
	BCF	PORTD, OE1, A	;set oe1 low to read the output
	call	shortDelay
	movf	PORTE, W, A	;move output into wreg
	BSF	PORTD, OE1, A	
	return	0
	
; simple read function without connected memory
readTest2:
	BCF	PORTD, OE2, A	;set oe1 low to read the output
	call	shortDelay
	movf	PORTE, W, A	;move output into wreg
	BSF	PORTD, OE2, A	
	return	0
start:
	call	setup		;setup pins
	call	shortDelay
	call	shortDelay
	call	writeTest1	; write to chip 1
	call	shortDelay
	call	shortDelay
	call	writeTest2	; write to chip 2
	call	shortDelay
	call	shortDelay
	call	readTest1	; read chip 1
	movwf	mem1, A		; store value somewhere
	call	shortDelay
	call	shortDelay
	call	readTest2	; read chip 2
	movwf	mem2, A		; store value somewhere else
	
	goto	main