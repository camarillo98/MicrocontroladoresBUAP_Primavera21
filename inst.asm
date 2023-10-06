;Un programa en ensamblador no solo tiene instrucciones, también tiene directivas
;Programa de ejemplo de uso de instrucciones
;Un progama de DIRECTIVAS e INSTRUCCIONES	
;Columna 0 solamente para etiquetas
;19 de enero de 2020
			List P=18F4550				;Tipo de procesador
			include <P18F4550.inc>		;Contiene las direcciones de los SFR (Registros de función especial)
cont	equ 0							;Le asignamos a cont la dirección 0
reg 	equ 1 
				movlw	0x23			;Asignamos el valor c2 en el registro W
				movwf	cont 			;Ahora cont tiene el valor que tiene W
				movlw 	0x02 
				movwf	reg
incre			incf	cont,1,0		;Incrementamos cont=cont+1
				swapf 	cont, 1, 0		;Intercambia nibles en cont (nible es medio byte)
				addwf 	cont ,1,0  		;w = cont + w
				decfsz 	reg,1			;reg=reg-1
				andwf 	reg,0,0			;wreg = reg and wreg
				goto 	incre 			;salto incondicional a la etiqueta incre
				end 

;Project Wizard > Siguiente > Seleccionar PIC > siguiente
;Seleccionar herramienta de lenguaje (MPASM) > Siguiente > 
;Para compilar: make