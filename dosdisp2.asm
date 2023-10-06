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
		cblock		0x0	;ejemplo de definición de variables en RAM de acceso
		flags			;banderas
		iun				;índice de unidades	
		cuni			;código de 7 segmentos de unidades
		idec			;índice de decenas
		cdec			;código de 7 segmentos de decena
		cont
		endc			;fin de bloque de constantes
;Todo lo anterior son palabras de configuración
;****************************************************************************asdasd
;Reset vector
		ORG 0x0000
		bra 	inicio
		org		0x08					; Vector de interrupción de alta prioridad
		bra		RSI	
		org		0x18					; Vector de interrupción de baja prioridad
		bra		ST2
;Inicio del programa principal
inicio	bsf		OSCCON, IRCF2, 0	
		bsf 	OSCCON, IRCF1, 0
		bcf		OSCCON, IRCF0, 0		; 110, Oscilador interno a 4 MHz
		movlw 	0x0F
		movwf	ADCON1, 0				; Puertos digitales
		clrf 	PORTD, 0
		clrf 	TRISD, 0				; Puerto D configurado como salida
		clrf	TRISA, 0				; Puerto A configurado como salida
		bcf 	TRISB, 3				; RB3 salida
		movlw	0xF0					; 1111 0000
		movwf	INTCON, 0				; Interrupciones externa INT0, TMR0 y PEIE

		movlw	0x95
		movwf	T0CON					; Timer 16 bits, preescaler *64
		movlw	0xE1
		movwf	TMR0H, 0
		movlw	0x7C
		movwf	TMR0L, 0				; Valor de precarga para 1000ms a 4 MHz, preescaler 64 del timer0
		
		clrf	TBLPTRL, 0				
		movlw	0x03					
		movwf	TBLPTRH, 0				; El apuntador TBLPTRH se pone en dirección 0x03
		clrf	TBLPTRU, 0				; tblptr = 0x000300
		movlw	0x05
		movwf	PR2						; Timer2 period register
		movlw	0x07
		movwf	T2CON					; 
		bsf		PIE1, TMR2IE			; Interrupción timer2 activa

		clrf	iun, 0
		clrf	idec, 0					; Iniciamos en cero
		
		bsf 	RCON, IPEN				; Activamos prioridades de interrupción
		bcf		IPR1, TMR2IP			; Timer2 en baja prioridad de interrupción
; Subrutina Lee donde se pasa el valor de "iun" al apuntador "TBLPTRL" y se lee su valor
; Se mueve el valor de donde el apuntador apuntó (donde ahora está TABLAT) al código de las unidades y se repite el proceso
; con los decimales (Lo que hace la sr lee es que va a conseguir los códigos para mostrar los números en los displays)
lee		movff	iun, TBLPTRL			; ajusta apuntador (unidades)
		tblrd	*						; lee la tabla sin modificar apuntador
		movff	TABLAT, cuni			; Cuni tiene código 7 segmentos

		movff	idec, TBLPTRL			; ajusta apuntador (decimales)
		tblrd	*						; Lee la tabla sin modificar apuntador
		movff	TABLAT, cdec			; cdec tiene código 7 segmentos
; Inicio del programa principal
loop	movlw	0x01					
		movwf	PORTA,0					; encendemos display unidades
		movff	cuni, PORTD				; Mueve el valor del código de las unidades al puerto D (Codigo UNIdades)
		call	delay					; Timer2 establecerá el tiempo que esté encendido el display

		movlw	0x02					
		movwf	PORTA, 0				; encendemos display decenas
		movff	cdec, PORTD				; Mueve el valor del código de las decenas (Codigo DECenas)
		call	delay					; Timer2 establecerá el tiempo que esté encendido el display

		btfss	flags, 0, 0
		bra		loop
; Programa principal de loop hasta acá jejeps
		bcf		flags, 0, 0				; ¿Ya transcurrieron 500 ms?
		incf	iun, F, 0				; Se incrementan los índices de unidades
		movf	iun, W, 0				; Se mueve el valor de iun a wreg
		xorlw	0x0a
		btfss	STATUS, Z, 0			; verifica límite de tabla (si se hace 0 con la operación quiere decir que llegó al límite que pusimos)
		bra		lee
		clrf	iun, 0

		incf	idec, F, 0
		movf	idec, W, 0
		xorlw	0x0a
		btfss	STATUS, Z, 0
		bra		lee
		clrf	idec, 0
;*************************************************************************************	
		

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
		reset	
		btg		PORTB, 3				; puerto monitor de interrupción
		retfie
;*************************************************************************************
ST2		bcf		PIR1, TMR2IF			;Peripheral Interrupts Request 1 & Timer2 Interrupt flag bit
		bsf		flags, 2				; Bandera monitor del timer2
		retfie
;*************************************************************************************
delay	btfss	flags, 2
		bra		delay
		bcf		flags, 2
		return

;*************************************************************************************
		org		0x300					; DB Directiva que Define Byte
		DB		0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xB8, 0x80, 0x98, 0x88, 0x83, 0xc6, 0xa1, 0x86, 0x8e
		END