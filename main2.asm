	LIST		p=16F887	;Tipo de microcontrolador
	INCLUDE 	P16F887.INC	;Define los SFRs y bits del 
					;P16F88
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC		
	errorlevel	 -302		;Deshabilita mensajes de 
					;advertencia por cambio bancos
	CBLOCK		0X020
	counter
	counter2
	counter1
	endc
Org		0x00		; vector de reset
Goto	main		; salto a "main"
main
	banksel	ANSEL		;Bank containing register ANSEL
	clrf	ANSEL		;Clears registers ANSEL and ANSELH
	clrf	ANSELH		;All pins are digital
	banksel TRISC
	clrf TRISC		; salidas en el puerto c
	banksel TRISB
	movlw 	b'00111111'
	movwf	TRISB		;PORTB COMO ENTRADAS excepto pin 6 y 7	
	banksel PORTC
	clrf PORTC
	;; *****************************************MAIN*****************************
		lazo
	call banda2_llenarCaja
	goto lazo

	banda2_llenarCaja
	CALL DELAY
	banksel PORTB
	btfss PORTB,1
	goto seguir
	bsf PORTC,2
	return
seguir
	bcf PORTC,2
	return


DELAY
       clrf        counter2        ; Clears variable "counter2"
loop1
       clrf        counter1        ; Clears variable "counter1"
loop2
       decfsz      counter1        ; Decrements variable "counter1" by 1
       goto        loop2           ; Result is not 0. Go to label loop2
       decfsz      counter2        ; Decrements variable "counter2" by 1
       goto        loop1           ; Result is not 0. Go to lab loop1
       return                      ; Return from subroutine "DELAY"
end
