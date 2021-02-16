	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
errorMessage:
	movlw	0xAA
	movwf	PORTC, A
	return	0
start:
;	movlw 	0x55
;	movwf	0x50, A	    
;	movlw	0x00
;	movwf	0x10, A
    
	c0	equ 0x10
	c1	equ 0x20
	init	equ 0x330
	len	equ 0x03
	
	movlw	0x00
	movwf	c0, A
	movwf	c1, A
	movwf	TRISC, A
	
	lfsr	0, init
	lfsr	1, init
writeLoop:
	movf	c0, W, A
;	movlw	0x00
	movwf	POSTINC0, A
	incf	c0, A
	movlw	len
	cpfsgt	c0, A
	bra	writeLoop
	
readLoop:
	movf	POSTINC1, W, A
	cpfseq	c1, A
	call	errorMessage
	incf	c1, A
	movlw	len
	cpfsgt	c1, A
	bra	readLoop
	
	
	
;loop:
;	movf	0x10, W, A
;	movwf	0x20, A
;	incf	0x10, A
;	bra	loop
