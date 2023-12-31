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
		cont equ 0
;Todo lo anterior son palabras de configuración
;****************************************************************************
;Reset vector
		ORG 0x0000
;Inicio del programa principal
		bcf 	OSCCON, IRCF2, 0
		bsf 	OSCCON, IRCF0, 0		;El oscilador pasa de su valor predeterminado 100 (1 MHz) a 001 (125 KHz)
		movlw 	0x0F					;Se asigna un valor de 0000 1111 al Working Register
		movwf 	ADCON1, 0				;Con el valor asignado al Working register se configuran el registro de control A/D 1 (con el valor 0F {1111} se configuran todos los pines como digitales)
		clrf 	PORTD, 0
		clrf 	TRISD, 0				;Puerto D configurado como salida
		bsf 	PORTD, 0, 0				;enciende LED conectado en RD0
correi	rlcf 	PORTD, F, 0				;Rota a la izquierda
		call 	retardo
		bra		correi					;salta a ciclo infinito
;*****************************************************************************
retardo movlw	0xff
		movwf	cont, 0
nada	nop
		decfsz	cont, 1, 0
		bra 	nada
		return 
		END		
