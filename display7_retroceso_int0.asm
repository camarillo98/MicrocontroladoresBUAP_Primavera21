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
		cont
		ciclo
		flags
		endc
;Todo lo anterior son palabras de configuración
;****************************************************************************
;Reset vector
		ORG 0x0000
		bra 	inicio
		org		0x08
		bra		RSI
;Inicio del programa principal

inicio	bcf		OSCCON, IRCF2, 0		; 000, Oscilador interno a 32 KHz
		movlw 	0x0F
		movwf	ADCON1, 0				; Puertos digitales
		clrf 	PORTD, 0
		clrf 	TRISD, 0				; Puerto D configurado como salida
		movlw	0x90					; Binario 1001 0000
		movwf	INTCON					; Configuramos la interrupción externa INT0
cero	movlw	0xC0					; Código del cero
		movwf	PORTD, 0
		call	repite
		btfss	flags, 1, 0
		bra		f
uno		movlw	0xF9					; Código del uno
		movwf	PORTD, 0
		call	repite
		btfss	flags, 1, 0
		bra		cero
dos		movlw	0xA4					; Código del dos
		movwf	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		uno
tres	movlw	0xB0					; Código del tres
		movwf	PORTD, 0
		call	repite
		btfss	flags, 1, 0
		bra		dos
cuatro	movlw	0x99					; Código del cuatro
		movwf	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		tres
cinco	movlw	0x92					; Código del cinco
		movwf	PORTD, 0			
		call 	repite
		btfss	flags, 1, 0
		bra		cuatro
seis	movlw	0x82					; Código del seis
		movwf	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		cinco
siete	movlw	0xB8					; Código del siete
		movwf	PORTD, 0
		call	repite
		btfss	flags, 1, 0
		bra		seis					
ocho	movlw	0x80					; Código del ocho
		movwf	PORTD,0
		call 	repite
		btfss	flags, 1, 0
		bra		siete					
nueve	movlw	0x98					; Código del nueve
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		ocho
a		movlw	0x88					; Código del A
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		nueve
b		movlw	0x83					; Código del B
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		a
c		movlw	0xC6					; Código del C
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		b
d		movlw	0xA1					; Código del D
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		c
e		movlw	0x86					; Código del E
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		d
f		movlw	0x8E					; Código del F
		movwf 	PORTD, 0
		call 	repite
		btfss	flags, 1, 0
		bra		e

;*******RUTINA REPARTO Y NADA**********************************************************************
retardo movlw	0xff
		movwf	cont, 0
nada	nop
		decfsz	cont, 1, 0
		bra 	nada
		return 
;*****RUTINA REPITE Y LLAMA***********************************************************
repite	movlw	d'10'			;La d indica que es un dato en sistema decimal
		movwf	ciclo, 0
llama	call	retardo
		decfsz	ciclo, F, 0
		bra 	llama
		return 					; Regreso de subrutina
;*****RUTINA DE SERVICIO DE INTERRUPCIÓN**********************************************
RSI		bcf		INTCON, INT0IF	; Se apaga el bit de bandera
		btg		flags, 1		; Bit monitor de interrupción externa
		retfie 					; Regreso de servicio de interrupción
		END	