;*********************************************************************************
LIST P=18F4550							; Directiva para definir el procesador
#include <P18F4550.INC>					; Definición de variables específicas del procesador
;*********************************************************************************
;Bits de configuración
			CONFIG FOSC 	= INTOSC_XT		; Oscilador interno para uC, XT para el USB
			CONFIG BOR		= OFF			; BROWNOUT RESET DESHABILITADO
			CONFIG PWRT		= ON			; PWR UP Timer habilitado
			CONFIG WDT		= OFF			; Temporizador vigía apagado
			CONFIG MCLRE	= OFF			; Reset apagado
			CONFIG PBADEN 	= OFF
			CONFIG LVP 		= OFF	
;**********************************************************************************
			ORG 	0X0000
			bcf		OSCCON, IRCF0, 0			; Oscilador interno a 125 KHz 
			clrf 	WREG, 0
			lfsr	FSR0, 100h					; Carga apuntador con dirección inicial banco 1
NEXT		addwf	POSTINC0					; INDF+w después incrementa FSR0
			incf	WREG, 0
			btfss 	FSR0H, 1					; Terminamos con banco 1?
			bra		NEXT
CLEAN		clrf	POSTDEC0					; Limpia localidad, después incrementa FSR0
			movf	FSR0L, F, 0
			btfss	STATUS, Z, 0
			bra		CLEAN
HERE		bra		HERE
;***********************************************************************************
			END