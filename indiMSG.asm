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
;********************************************************************************** ORG 	0X0000
			cont	equ	2
			bcf		OSCCON, IRCF2, 0
			bsf		OSCCON, IRCF0, 0	;Oscilador interno a 125 KHz
			movlw	0x02
			movwf	TBLPTRH				;TBLPTR=0x200 apuntador a memoria de programa
			LFSR	FSR0, 100h			;Carga apuntador mem. datos con dirección inicial banco 1
			movlw	0x0b
next		tblrd 	*+
			movff	TABLAT, POSTINC0
			cpfslt	TBLPTRL
			clrf	TBLPTRL				;Inicio del mensaje
			btfss	FSR0H, 1				;Terminamos con banco 1?
			bra		next
aqui		bra		aqui
;***********************************************************************************
			org		0x200
			;DB		0x50, 0x52, 0x49, 0x4d, 0x41, 0x56, 0x45, 0x52, 0x41, 0x32, 0x31, 0x2d
			DB		'H', 'o', 'l', 'a', ' ', 'm', 'u', 'n', 'd', 'o'
			END 