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
;Definiciones de variables
		cblock		0x0
		flags
		ok
		endc
;Todo lo anterior son palabras de configuración
;****************************************************************************
;Reset vector
		ORG 0x0000
		bra 	inicio
		org		0x08
		bra		RSI

;Inicio del programa principal
inicio	bsf		OSCCON, IRCF2, 0	
		bsf 	OSCCON, IRCF1, 0
		bcf		OSCCON, IRCF0, 0		; 110, Oscilador interno a 4 MHz
		movlw 	0x0F
		movwf	ADCON1, 0				; Puertos digitales
		clrf 	PORTD, 0
		clrf 	TRISD, 0				; Puerto D configurado como salida
		movlw	0xB0
		movwf	INTCON, 0				; Configuramos interrupciones externa INT0 y TMR0
		movlw	0x95
		movwf	T0CON					; Timer 16 bits, preescaler *64
		movlw	0xE1
		movwf	TMR0H, 0
		movlw	0x7C
		movwf	TMR0L, 0				; Valor de precarga para 1000ms a 4 MHz, preescaler 64
		
		clrf	TBLPTRL, 0
		movlw	0x03					
		movwf	TBLPTRH, 0				; El apuntador TBLPTRH se pone en dirección 0x03
		clrf	TBLPTRU, 0				; tblptr = 0x000300

lee		btfss 	flags, 1, 0
		bra		parriba
		bra		pabajo

	
parriba	tblrd	*+
		movff	TABLAT, PORTD
		call 	espera
		movf	TBLPTRL, W, 0
		xorlw	0x10
		btfss	STATUS, Z, 0
		bra		lee
		clrf	TBLPTRL, 0
		goto	lee

pabajo	tblrd	*-
		movff	TABLAT, PORTD
		call	espera
		movf	TBLPTRL, W, 0
		xorlw	0xff
		btfss	STATUS, Z, 0
		bra		lee
		movlw	0x0f
		movwf	TBLPTRL, 0
		movlw	0x03
		movwf	TBLPTRH, 0
		goto	lee
		

;*****RUTINA DE SERVICIO DE INTERRUPCIÓN**********************************************
RSI		btfss	INTCON, TMR0IF
		bra		SINT0
		bcf		INTCON, TMR0IF
		movlw	0xC2
		movwf	TMR0H, 0
		movlw	0xF7
		movwf	TMR0L, 0				; valor de precarga para 1000 ms a 4 MHz preescaler 64
		bsf		flags, 0				; monitor interrupción del timer 0
		retfie
SINT0	bcf		INTCON, INT0IF			; apaga bit de bandera
		btg		flags, 1				; bit monitor de interrupción
		retfie
;*************************************************************************************
espera	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espera
		bcf 	flags, 0
		return
;*************************************************************************************
		org		0x300					; DB Directiva que Define Byte
		DB		0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xB8, 0x80, 0x98, 0x88, 0x83, 0xc6, 0xa1, 0x86, 0x8e
		END