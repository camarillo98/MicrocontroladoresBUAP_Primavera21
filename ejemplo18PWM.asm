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
		ciclo
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
		movlw	0x1C				; 0001 1100
		movwf	CCP1CON				; modo pwm
		movlw	0x07
 	 	movwf	T2CON, 0			; Configuración preescaler timer 2x16
		movlw	d'194'
		movwf	PR2, 0				; Periodo PWM 100 ms
		bcf		TRISC, 0, 0		
		bcf		TRISC, 1, 0		
		bcf		TRISC, 2, 0			; PIN ccp1 SALIDA
		movlw	0x75
		movwf	CCPR1L, 0			; Ciclo de trabajo al 60% (60 ms)
		bsf		PORTC, 0			; Enciende LED conectado en RD0
		bsf		PORTC, 1			; Enciende LED conectado en RD0
		bsf		PORTD, 0			; Enciende LED conectado en RD0
correi	rlcf	PORTD, F
		call	repite
		btg		PORTD, 4
		call	retardo
		bra		correi				; salta a ciclo infinito
;****************************************************************************************************
retardo	movlw	0xff
		movwf	cont, 0
nada	nop
		decfsz	cont, F, 0
		bra		nada
		return
;****************************************************************************************************
repite	movlw	d'10'
		movwf	ciclo, 0
llama	call	retardo
		decfsz	ciclo, 1, 0
		bra		llama
		return
		END