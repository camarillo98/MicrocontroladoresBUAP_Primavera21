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
		movwf	TMR0L, 0				; Valor de precarga para 500ms a 4 MHz, preescaler 64
cero	movlw	0xC0					; Código del cero
		movwf	PORTD, 0
esp0	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp0
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra f

uno		movlw	0xF9					; Código del uno
		movwf	PORTD, 0
esp1	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp1
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	cero
		
dos		movlw	0xA4					; Código del dos
		movwf	PORTD, 0
esp2	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp2
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra uno
	
tres	movlw	0xB0					; Código del tres
		movwf	PORTD, 0
esp3	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp3
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	dos
	
cuatro	movlw	0x99					; Código del cuatro
		movwf	PORTD, 0
esp4	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp4
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	tres
		
cinco	movlw	0x92					; Código del cinco
		movwf	PORTD, 0
esp5	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp5
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	cuatro			
		
seis	movlw	0x82					; Código del seis
		movwf	PORTD, 0
esp6	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp6
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra		cinco
	
siete	movlw	0xB8					; Código del siete
		movwf	PORTD, 0
esp7	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp7
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	seis
					
ocho	movlw	0x80					; Código del ocho
		movwf	PORTD,0
esp8	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp8
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	siete 
					
nueve	movlw	0x98					; Código del nueve
		movwf 	PORTD, 0
esp9	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		esp9
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	ocho
	
a		movlw	0x88					; Código del A
		movwf 	PORTD, 0
espa	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espa
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	nueve
		
b		movlw	0x83					; Código del B
		movwf 	PORTD, 0
espb	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espb
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	a
	
c		movlw	0xC6					; Código del C
		movwf 	PORTD, 0
espc	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espc
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	b
		
d		movlw	0xA1					; Código del D
		movwf 	PORTD, 0
espd	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espd
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	c
	
e		movlw	0x86					; Código del E
		movwf 	PORTD, 0
espe	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espe
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	d
	
f		movlw	0x8E					; Código del F
		movwf 	PORTD, 0
espf	btfss	flags, 0				; ¿pasaron 500 ms?
		bra		espf
		bcf 	flags, 0
		btfss	flags, 1, 0				; verifica dirección de conteo
		bra 	e
		bra		cero
		

;*****RUTINA DE SERVICIO DE INTERRUPCIÓN**********************************************
RSI		btfss	INTCON, TMR0IF
		bra		SINT0
		bcf		INTCON, TMR0IF
		movlw	0xE1
		movwf	TMR0H, 0
		movlw	0x7C
		movwf	TMR0L, 0				; valor de precarga para 500 ms a 4 MHz preescaler 64
		bsf		flags, 0				; monitor interrupción del timer 0
		retfie
SINT0	bcf		INTCON, INT0IF			; apaga bit de bandera
		btg		flags, 1				; bit monitor de interrupción
		retfie
		END