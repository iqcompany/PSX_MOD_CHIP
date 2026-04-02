	list    P=12C508
	radix   dec
	include "p12c508.inc"
	__FUSES _MCLRE_OFF & _CP_OFF & _WDT_OFF & _XT_OSC
	cblock	0x07
		i
		j
		k
		x
		y
		xmit
		index
		mode
	endc
	org	0x00
	movwf	OSCCAL
	goto	start
dly50	movlw	50
dly_ms	movwf	x
dy_0	movlw	249
	movwf	y
dy_1	nop
	decfsz	y,F
	goto	dy_1
	decfsz	x,F
	goto	dy_0
	btfss	mode,0
	retlw	3
	movlw	36
	movwf	y
dy_2	decfsz	y,F
	goto	dy_2
	retlw	3
sendln	movwf	i
sl_0	movlw	72
	call	dly_ms
	movlw	4
	movwf	j
sl_1	movf	index,W
	call	lines
	movwf	xmit
	comf	xmit,F

	movlw	8
	movwf	k
	movlw	b'11111011'
	tris	GPIO
	movlw	4
	call	dly_ms

sl_2	rrf	xmit,F
	movlw	b'11111001'
	movwf	GPIO
	btfsc	STATUS,C
	movlw	b'11111011'
	btfss	STATUS,C
	movlw	b'11111001'
	tris	GPIO
	movlw	4
	call	dly_ms
	decfsz	k,F
	goto	sl_2
	movlw	b'11111001'
	tris	GPIO
	movlw	8
	call	dly_ms
	incf	index,F
	decfsz	j,F
	goto	sl_1
	decfsz	i,F
	goto	sl_0
	retlw	3
lines	addwf	PCL,F
	dt	'S','C','E','I'
	dt	'S','C','E','A'
	dt	'S','C','E','E'
	org	0x0100
start	movlw	b'11000010'
	option
	movlw	b'11111111'
	tris	GPIO
	clrf	mode

	call	dly50
	bcf	GPIO,1
	movlw	b'11111101'
	tris	GPIO

	movlw	17
	movwf	i
m01	call	dly50
	decfsz	i,F
	goto	m01
	bcf	GPIO,2
	movlw	b'11111001'
	tris	GPIO

	movlw	6
	movwf	i
m02	call	dly50
	decfsz	i,F
	goto	m02
	movlw	14
	call	dly_ms

m03	clrf	index
	call	sendln
	incf	mode,F
	goto	m03
	end
