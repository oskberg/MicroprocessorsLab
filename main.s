#include <xc.inc>

psect	code, abs
	
c0	equ 0x10    ; counter location
len	equ 0xFFFF    ; lenght of delay
hi	equ 0x20    ; high 16 bit
lo	equ 0x21    ; low 16 bit
outLim	equ 0xFE    ; break counting loop at this value
count	equ	0x11
lim1	equ	0xFE
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100

largeDelay:
	movlw	0x00
ldLoop:	; There is only no carry when going from 0 -> 0xFF for both hi and low
	decf	lo, f, A
	subwfb	hi, f, A
	bc	ldLoop	    ; loop if carry
	return 0	    ; return when no carry

	; set up the transfer pins and stuff
SPI_MasterInit:
	bsf	CKE
	
	movlw	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK) 
	movwf	SSP2CON1, A
	
	bcf	TRISD, PORTD_SDO2_POSN, A	
	bcf	TRISD, PORTD_SCK2_POSN, A
	return
	
	; transfers content of w over serial
SPI_MasterTransmit:
	movwf	SSP2BUF, A
; waits until everything has been transferred until contintuing
Wait_Transmit:
	btfss	SSP2IF
	bra	Wait_Transmit
	bcf	SSP2IF
	return
	
start:
	call	SPI_MasterInit
	
	movlw	0x01
	movwf	count, A
	
	
;	movlw	0x0f
;	call	SPI_MasterTransmit
;	movlw	0xf0
;	call	SPI_MasterTransmit
	
;	
counterLoop:
    	movlw	high(len)   ; reset delay value
	movwf	hi, A
	movlw	low(len)
	movwf	lo, A
	    
	call	largeDelay  ; call delay
    
	movf	count, W, A
	call	SPI_MasterTransmit
	incf	count, F, A
	movlw	lim1
	cpfsgt	count, A
	bra	counterLoop
	
	bra	start
