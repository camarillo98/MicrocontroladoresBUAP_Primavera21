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
		flags				; variable para almacenar el valor del puertoB
		endc
;****************************************************************************
; Reset vector
		ORG		0X0000
		bra		inicio
; Inicio del programa principal

inicio	bsf		OSCCON, IRCF2, 0
		bsf		OSCCON, IRCF1, 0
		bcf		OSCCON, IRCF0, 0			; 110 Oscilador interno a 4 MHz 
		movlw	0x0f
		movwf	ADCON1, 0					; Puertos configurados como salida
		setf	TRISA						; Puerto A definido como entrada
		setf	TRISB 						; Puerto B definido como entrada	
		clrf	TRISD 						; Puerto D definido como salida
		movlw	0xF0					; 1111 0000
		movwf	INTCON, 0				; Interrupciones externa INT0, TMR0 y PEI
		
;NOTA DO
doON	bsf		TRISD, 0
		btfss	flags, 0
		bra		doON
doOFF	bcf		TRISD, 0
		btfss	flags, 0
		bra		doOFF
		bra		doOFF


;::::::::::::::::::::::::::::::::::::::::::::
;SUBRUTINAS:SUBRUTINAS:SUBRUTINAS:SUBRUTINAS:
;::::::::::::::::::::::::::::::::::::::::::::
RSI		bcf		INTCON, TMR0IF
		movlw	0xFF
		movwf	TMR0H, 0
		movlw	0xC4
		movwf	TMR0L, 0				; valor de precarga para 500 ms a 4 MHz preescaler 64
		bsf		flags, 0				; monitor interrupción del timer 0
		retfie
		


		END
		
		