	LIST P=18F4550		;directiva para definir el procesador
		#include <P18F4550.INC>	;definiciones de variables especificas del procesador
		
;****************************************************************************
;Bits de configuración
			CONFIG FOSC = INTOSC_XT ;Oscilador interno para el uC, XT para USB
			CONFIG BOR = OFF		;Brownout reset deshabilitado
			CONFIG PWRT = ON		;Pwr up timer habilitado
			CONFIG WDT = OFF		;Temporizador vigia apagado
			CONFIG MCLRE = OFF		;Reset apagado
			CONFIG PBADEN = OFF
			CONFIG LVP = OFF
;****************************************************************************
;Definición de variables
		cblock	0x0
		cont
		codigo
		pwm
		displayT
		indices
		endc
;****************************************************************************
; Reset vector
		ORG		0X0000
		bra		inicio
		ORG		0x08
		bra		RSI
; Inicio del programa principal
inicio	bcf		OSCCON, IRCF2, 0
		bsf		OSCCON, IRCF0, 0	; Oscilador interno a 125 kHz
		movlw	0x0F
		movwf	ADCON1, 0			; Puertos digitales
		clrf	PORTD, 0			
		clrf	TRISD, 0			; Puerto D configurado como salida
		movlw	0xF0			
		movwf	TRISA				; RA3:RA0 salidas para multiplexar displays

;CONFIGURANDO INTERRUPCIÓN 2
		bcf 	TRISB, 3			; RB3 salida
		bcf		INTCON3, INT2IF		; INT1IF = 0
		bsf		INTCON3, INT2IE		; Enable INT1
		bsf		INTCON, GIE
		movlw	0x0F				; Configuramos INT0-INT2 como entradas digitales
		movwf	ADCON1
;INTERRUPCIÓN
		movlw	0x1C				; 0001 1100
		movwf	CCP1CON				; modo PWM
		movlw	0x07
		movwf	T2CON, 0			; Configuración preescaler timer2 x 16
		movlw	d'194'
		movwf	PR2, 0				; Periodo PWM 100 ms
		bcf		TRISC, 2, 0			; PIN ccp1 SALIDA (hacia el osciloscopio)

		movlw 	0x03
		movwf	TBLPTRH				; TBLPTR = 0x000300
		movlw	0x13
		movwf	CCPR1L, 0			; PWM a 10%

		movlw	0x16
		movwf	displayT
		movlw	0x06
		movwf	pwm	

start	movff	indices, TBLPTRL
		tblrd	*
		movff	TABLAT, PORTA
		movff	codigo, TBLPTRL
		tblrd	*
		movff	TABLAT, PORTD

		call	retardo
		incf	indices
		incf	codigo
		movff	codigo, WREG
		xorlw	0x03
		btfsc	STATUS, Z, 0
		bra		thrddsply	
		movff	indices, WREG
		xorlw	0x13
		btfsc	STATUS, Z, 0
		bra		thrddsply
		bra		start
				
thrddsply	movlw	0x00
			movwf	codigo
			movlw	0x10
			movwf	indices
			movlw	0x04
			movwf	PORTA
			movff	displayT, TBLPTRL
			tblrd	*
			movff	TABLAT, PORTD
			movff	pwm, TBLPTRL
			tblrd	*
			movff	TABLAT, CCPR1L		
			call	retardo
			bra		start
;*************************************************************************************
retardo	movlw	0x7f				; esta rutina tarda 64 ms en ejecutarse
		movwf	cont, 0
nada	nop
		decfsz	cont, F, 0
		bra		nada
		return

RSI		bcf		INTCON3, INT2IF
		movff	displayT, WREG
		xorlw	0x1F
		btfsc	STATUS, Z, 0
		bra		clrPWM
		incf	displayT
		incf	pwm
		movff 	pwm, TBLPTRL
		tblrd	*
		movff	TABLAT, CCPR1L
		movff	displayT, WREG
		xorlw	0x1F
		btfss	STATUS, Z, 0
		retfie
clrPWM	movlw	0x06
		movff	WREG, pwm
		movlw	0x16	
		movff	WREG, displayT	
		retfie
;*************************************************************************************
		org		0x300						; dirección para el código de los displays
		DB		0xa1, 0xa7, 0xc0		; dc_0
		org		0x306						; dirección para el pwm
		DB		0x13, 0x27, 0x3A, 0x4e, 0x61, 0x75, 0x88, 0x9c, 0xaf
		org		0x310						; indica que display se encenderá
		DB		0x01, 0x02, 0x08			
		org		0x316						; códigos del 1-9 para el tercer display del pwm
		DB		0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xb8, 0x80, 0x98
		END