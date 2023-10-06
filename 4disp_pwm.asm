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
		num
		endc
;****************************************************************************
; Reset vector
		ORG		0X0000
; Inicio del programa principal
		bcf		OSCCON, IRCF2, 0
		bsf		OSCCON, IRCF0, 0	; Oscilador interno a 125 kHz
		movlw	0x0F
		movwf	ADCON1, 0			; Puertos digitales
		clrf	PORTD, 0			
		clrf	TRISD, 0			; Puerto D configurado como salida
		movlw	0xF0			
		movwf	TRISA				; RA3:RA0 salidas para multiplexar displays
		movlw	0x1C				; 0001 1100
		movwf	CCP1CON				; modo PWM
		movlw	0x07
		movwf	T2CON, 0			; Configuración preescaler timer2 x 16
		movlw	d'194'
		movwf	PR2, 0				; Periodo PWM 100 ms
		bcf		TRISC, 2, 0			; PIN ccp1 SALIDA
		movlw	0x75
		movwf	TBLPTRH				; TBLPTR = 0x000300
		movlw	0x04	
		movwf	num					; Se muestran 4 letras
loop	movlw	0x01
		movwf	PORTA				; enciende primer display
lee		tblrd	*+
		movff	TABLAT, PORTD
		call	retardo
		rlcf	PORTA, 1			; enciende siguiente display
		movf	num, W
		cpfslt	TBLPTRL
		bra		ini
		bra		lee
ini		clrf	TBLPTRL
		bra		loop
;*************************************************************************************
retardo	movlw	0x7f				; esta rutina tarda 64 ms en ejecutarse
		movwf	cont, 0
nada	nop
		decfsz	cont, F, 0
		bra		nada
		return
;*************************************************************************************
		org		0x300
		DB		0x89, 0xc0, 0xc7, 0x88, 0xff
		END