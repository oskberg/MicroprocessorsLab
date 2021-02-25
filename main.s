#include <xc.inc>

psect	code, abs

count	equ	0x11
lim1	equ	0xFE
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100

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
	movf	count, W, A
	call	SPI_MasterTransmit
	incf	count, F, A
	movlw	lim1
	cpfsgt	count, A
	bra	counterLoop
	
	bra	start