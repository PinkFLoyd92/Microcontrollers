	LIST		p=16F887	;Tipo de microcontrolador
	INCLUDE 	P16F887.INC	;Define los SFRs y bits del 
					;P16F88
	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_XT_OSC	
					;Setea parámetros de 
					;configuración

	errorlevel	 -302		;Deshabilita mensajes de 
					;advertencia por cambio bancos
	CBLOCK		0X020
	counter_tmr0
	counter1
	counter2
	unidades	;registro de unidades
	uni_cod	;Código de 7 segmentos de unidades
	contador
	decenas
	sel
	dec_cod
	ENDC
	;************************START OF PROGRAM ***********************			     ; forma de iniciar programa que usa interrupciones	
	
	org		0x00		; vector de reset
	goto	main			; salto a "main"
	org		0x04        	; vector de interrupción  
	goto	INTERRUPT 		; salto a interrupción
	org		0x05  		; continuación de programa

;************************ MAIN PROGRAM *************************
; inicio de programa principal
;***************************************************************
;SETEO DE PUERTOS Y REGISTROS       	

INTERRUPT
	;; btfss INTCON INTF
	goto banda1_interrupcion
	;; goto banda2_interrupcion
main
	banksel	ANSEL		;Bank containing register ANSEL
	clrf	ANSEL		;Clears registers ANSEL and ANSELH
	clrf	ANSELH		;All pins are digital
	clrf	sel
	CLRF	contador
	CLRF	unidades
	CLRF	decenas

        call banda1_puertos
	call habilitarInterrupciones
	;; TIMER0 USADO COMO TEMPORIZADOR PARA CONTAR
	call banda1_contarProductos


;;------------MAIN******************************************** 
	lazo
	call banda2_iniciar
	goto lazo


;;****************************funciones************************
banda2_iniciar
	btfsc PORTB,5
	goto seguir
	call banda2_decrementarProducto
seguir
	return	
;;****************DELAY - *******************************
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

DELAY2
	call DELAY
	call DELAY
	CALL DELAY
return
;;****************Tabla - *******************************
tabla
        ADDWF   PCL,F       	; PCL + W -> PCL
						; El PCL se incrementa con el 
						; valor de W proporcionando un 
						; salto
       	RETLW   0x3F     	; Retorna con el código del 0
		RETLW	0x06		; Retorna con el código del 1
		RETLW	0x5B		; Retorna con el código del 2
		RETLW	0x4F		; Retorna con el código del 3
		RETLW	0x66		; Retorna con el código del 4
		RETLW	0x6D		; Retorna con el código del 5
		RETLW	0x7D		; Retorna con el código del 6
		RETLW	0x07		; Retorna con el código del 7
		RETLW	0x7F		; Retorna con el código del 8
		RETLW	0x67		; Retorna con el código del 9

	;**********************HABILITAR INTERRUPCIONES*********************
habilitarInterrupciones
	banksel	INTCON
	clrf	INTCON			;habilita interrupción
	bsf		INTCON,GIE		;GIE=1 (BIT 7)
					; habilita interrupciones globales
	;; bsf		INTCON,INTE		;INTE=1 (BIT 4)
					; habilita interrupciones por señal INT
	bsf		INTCON,T0IE		;T0IE01	(BIT 5)
					; habilita interrupciones por desbordamiento de TMR0
	movlw	.100			;Cantidad de interrupciones a contar
	movwf	contador		;Nº de veces a repetir la interrupción
	return
	

;;; ***********************BANDA 1********************************
banda1_puertos
	banksel TRISC
	clrf TRISC		; salidas en el puerto c
	banksel TRISB
	movlw 	b'00111111'
	movwf	TRISB		;PORTB COMO ENTRADAS excepto pin 6 y 7
	banksel PORTB
	CLRF	PORTB
	banksel PORTC
	clrf PORTC
	return

banda1_contarProductos
	BANKSEL TMR0
	clrf TMR0
	BANKSEL OPTION_REG
	movlw		b'00000111'	;TMR0 como temporizador
	movwf		OPTION_REG  	;con preescaler de 256 
	BANKSEL	TMR0		;Selecciona el Bank0
	movlw		.217		;Valor decimal 217	
	movwf		TMR0		;Carga el TMR0 con 217
	return

banda2_decrementarProducto
		call DELAY2
		bcf	unidades,0
		movf	unidades,w  
		call	tabla
		movwf	uni_cod
		movf 	uni_cod,w
		bsf	PORTB,6
		bsf	PORTB,7
		movwf	PORTC
		bcf	PORTB,6
		comf	sel,f
	return


	;; ****************************************INTERRUPCIONES*****************************************
;; banda2_interrupcion
	;; call banda2_decrementarProducto
	;; bcf INTCON,INTF
	;; retfie
banda1_interrupcion
	;; *********************CONTANDO PRODUCTOS EN BANDA 1************************
	movf	sel,w		;Se mueve a si mismo para afectar bandera
	btfss	STATUS,2	;sel=0 refresca dig1; sel=1 refresca dig2
	goto	dig2
	dig1	 	
		movf	unidades,w  
		call	tabla
		movwf	uni_cod
		movf 	uni_cod,w
		bsf	PORTB,6
		bsf	PORTB,7
		movwf	PORTC
		bcf	PORTB,6
		comf	sel,f
		goto 	dec
	dig2	
		movf	decenas,w  
		call		tabla
		movwf	dec_cod
		movf 	dec_cod,w
		bsf	PORTB,6
		bsf	PORTB,7
		movwf	PORTC
		bcf	PORTB,7
		comf	sel,f	
	dec
		decfsz 	contador,f		;cuenta espacios de 10ms
		goto	Seguir			;Aún, no son 100 interrupciones
		INCF 	unidades,f		;Ahora sí 10x100=1000ms=1seg
		movlw	.10
		subwf	unidades,w
		btfss	STATUS,2
		goto	cont
		clrf	unidades
		incf	decenas
		movlw	.10
		subwf	decenas,w
		btfss	STATUS,2
		goto	cont
		clrf	decenas
	cont
	 	movlw 	.100		
       	movwf 	contador   		;Carga contador con 100
	Seguir   
		bcf	INTCON,T0IF		;Repone flag del TMR0 
		movlw 	~.39
       	movwf 	TMR0      		;Repone el TMR0 con ~.39
	retfie

end
