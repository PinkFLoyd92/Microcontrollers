LIST		p=16F887		;Tipo de microcontrolador
	INCLUDE 	P16F887.INC	;Define los SFRs y bits del 
								;P16F887

	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_INTOSCIO
								;Setea parámetros de 
								;configuración

	errorlevel	 -302			;Deshabilita mensajes de 
						;advertencia por cambio 
						;bancos
;*********************************************************************	
;DEFINICION DE VARIABLES
; las variables en el 16F887 pueden escribirse a partir de la 
;posición de memoria de datos 0x20

       cblock  0x20            ; Block of variables starts at address 20h
	counter                	; Variable "counter" at address 20h
	cuenta
	contador
	counter2
	counter1
	counters1
	counters2
	caja1
	caja2
	caja3
	caja4
	caja5
	caja6
	caja7
	caja8
	caja9
	numCaja
	unidades	;registro de unidades
	uni_cod	;Código de 7 segmentos de unidades
	endc
;************************************************************************
;INICIO DEL PROGRAMA
	Org		0x00		; vector de reset
	goto	main		; salto a "main"
	Org		0x04        ; vector de interrupción  
	goto	interrupcion		; salto a interrupción
	org		0x05  		; continuación de programa
	;SETEO DE PUERTOS
main
        banksel TRISB     ; Selects bank containing register TRISB
	movlw b'10000010' ;Pin 0 del puerto B como INPUT, pin RB7

	MOVWF TRISB
	banksel TRISA
	CLRF TRISA		;Puerto A como salida para display
	banksel TRISC
	clrf TRISC
	banksel TRISD
	clrf TRISD
        banksel 	ANSEL
	clrf	       	ANSEL
	clrf		ANSELH
	movlw .150
	movwf cuenta
	;INICIALIZACION DE VARIABLES
	call iniciarCajas	;se inicializan las variables que tienen que ver con el conteo de cajas.
	clrf	counter
	clrf	PORTD
	clrf	PORTC

	clrf		unidades
;*************Interupciones_Habilitada*************************

	banksel	INTCON
	clrf	INTCON			;habilita interrupción
	bsf		INTCON,GIE		;GIE=1 (BIT 7)
					; habilita interrupciones globales
	bsf		INTCON,RBIE		;INTE=1 (BIT 4)
	BANKSEL	IOCB
	MOVLW b'10000000' 	;se activa la interrupcion causada por el pin 7 del puerto B
	MOVWF IOCB		;interrupcion activada
;DESARROLLO DEL PROGRAMA      
;se cargan patrones alternados de unos y ceros en el puerto B
				;entre cada patrón de números se llama a un retardo.
	banksel PORTB
	CLRF PORTB
	movlw	.217		;Valor decimal 217	
	movwf	TMR0		;Carga el TMR0 con 217
	movlw	.100		;Cantidad de interrupciones a contar
	movwf	contador	;Nº de veces a repetir la interrupción
				;MOSTRAR CERO INICIAL
	movlw .1
	movwf PCLATH
	
	call	tabla
	movwf	PORTA
	call DELAY
	; INCF 	unidades,f
inicio
	
	banksel PORTB
	btfsc PORTB,1
	GOTO inicio
	GOTO START

START
cubeta_o
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	decfsz cuenta,1
	GOTO cubeta_o

	clrf PORTD
	CLRF PORTC
	movlw .150
	movwf cuenta
cubeta_1
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo

	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'000001000'
	movwf	PORTD
	call retardo


	MOVLW	b'10111111'
	movwf	PORTC
	
	MOVLW	b'00001000'
	movwf	PORTD
	call retardo
	MOVLW	b'11011111'
	movwf	PORTC
	
	MOVLW	b'00010000'
	movwf	PORTD
	call retardo

	MOVLW	b'11101111'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO cubeta_1

		
	clrf PORTD
	CLRF PORTC
	movlw .150
	movwf cuenta
	call DELAY

cubeta_2
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	MOVLW	b'10011111'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	MOVLW	b'11110011'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO cubeta_2
	CALL DELAY
	movlw .150
	movwf cuenta
	
	clrf PORTD
	CLRF PORTC

cubeta_3
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo

	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	
	MOVLW	b'00000001'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO cubeta_3
	CALL DELAY

	movlw .150
	movwf cuenta
	clrf PORTD
	CLRF PORTC
		
cubeta_4
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; *****************************
	MOVLW	b'00001111'
	movwf	PORTC
	
	MOVLW	b'00100100'
	movwf	PORTD
	call retardo

	
	MOVLW	b'11100001'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo

	
	MOVLW	b'11101111'
	movwf	PORTC
	
	MOVLW	b'000111000'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO cubeta_4
	
	call DELAY

	movlw .150
	movwf cuenta
	
	clrf PORTD
	CLRF PORTC
	
cubeta_5
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; ******************************************************************


	MOVLW	b'00001111'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	MOVLW	b'11110000'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO cubeta_5
	CALL DELAY
	movlw .150
	movwf cuenta
	
	clrf PORTD
	CLRF PORTC
cubeta_6
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	; ****************************************************
	MOVLW	b'00000001'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	MOVLW	b'11110011'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	decfsz cuenta,1
	GOTO cubeta_6
	call DELAY
	
	movlw .150
	movwf cuenta
	clrf PORTD
	CLRF PORTC

cubeta_7
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	;; *******************************************
	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO cubeta_7

	movlw .150
	movwf cuenta
	
	clrf PORTD
	CLRF PORTC
cubeta_8
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; ********************************
	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'00100100'
	movwf	PORTD
	call retardo

	MOVLW	b'01110010'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo
	
	decfsz cuenta,1
	GOTO cubeta_8

	clrf PORTD
	CLRF PORTC
	movlw .150
	movwf cuenta


	clrf PORTD
	CLRF PORTC
	
	goto inicio
	

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
       return    	

iniciarCajas
	clrf caja1
	clrf caja2
	clrf caja3
	clrf caja4
	clrf caja5
	clrf caja6
	clrf caja7
	clrf caja8
	clrf caja9
	movlw .1
	movwf numCaja

	;; *********************INICIO-> DISPLAY********************
	;; movlw b'00111111'
	;; call tabla
	;; movwf uni_cod
	;; movf 		uni_cod,w
	;; movwf		PORTA
	return


; TABLA DE CONVERSION

tabla
        	ADDWF   PCL,F       ; PCL + W -> PCL
					; El PCL se incrementa con el 
					; valor de W proporcionando un 
					; salto
       	RETLW   0x3F     	; Retorna con el código del 0
RETLW	 0x06		; Retorna con el código del 1
		RETLW	0x5B		; Retorna con el código del 2
		RETLW	0x4F		; Retorna con el código del 3
		RETLW	0x66		; Retorna con el código del 4
		RETLW	0x6D		; Retorna con el código del 5
		RETLW	0x7D		; Retorna con el código del 6
		RETLW	0x07		; Retorna con el código del 7
		RETLW	0x7F		; Retorna con el código del 8
		RETLW	0x67		; Retorna con el código del 9

retardo
	movlw	0x9c
	movwf	counters1
	movlw	0x02
	movwf	counters2
	retardo1
		decfsz	counters1,1
		goto	retardo1
		decfsz	counters2,1
		goto	retardo1
	return


                	
interrupcion
	btfsc	INTCON,RBIF
	goto	aumento_caja
	goto	final_interrupcion
aumento_caja
	BSF PORTB,3
	incf numCaja	;si el valor es 9 hay que cambiarlo a 1
	comf numCaja,0
	sublw	.246
	btfss	STATUS,Z	;si es 1 entonces el resultado es 0 de la resta 246-246
	goto pintar_numeroDiferentede1
	movlw b'00000001'
	movwf PCLATH
	movwf numCaja		;se resetea el número de caja
	movf numCaja,0
	call tabla
	movwf uni_cod
	movf uni_cod,0
	movwf	PORTA
	goto final_interrupcion
	;; ****************
pintar_numeroDiferentede1
	movlw .1
	movwf PCLATH
	movf numCaja,0
	call tabla
	movwf uni_cod
	movf 	uni_cod,0
	movwf	PORTA
final_interrupcion
	bcf INTCON, RBIF	;DESACTIVANDO bandera de interrupción.
	CALL DELAY
	BCF PORTB,3
	retfie

;; *******************************CAJAS*****************************************
incrementarcaja		;se incrementa la caja que este seleccionada.
	movlw .1
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja1
	
	movlw .2
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja2

	movlw .3
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja3
	
	movlw .4
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja4

	movlw .5
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja5
	
	movlw .6
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja6

	movlw .7
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja7
	
	movlw .8
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja8

	movlw .9
	subwf numCaja,0
	btfsc STATUS,Z
	incf caja9
return

	
pintar_valor1
	btfsc PORTB,1
	return
		MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo

	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'000001000'
	movwf	PORTD
	call retardo


	MOVLW	b'10111111'
	movwf	PORTC
	
	MOVLW	b'00001000'
	movwf	PORTD
	call retardo
	MOVLW	b'11011111'
	movwf	PORTC
	
	MOVLW	b'00010000'
	movwf	PORTD
	call retardo

	MOVLW	b'11101111'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO pintar_valor1

	clrf PORTD
	CLRF PORTC
	movlw .250
	movwf cuenta
	call incrementarcaja	;se incrementa la caja seleccionada.
	call DELAY
	return

pintar_valor2
	btfsc PORTB,1
	return
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	MOVLW	b'10011111'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	MOVLW	b'11110011'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO pintar_valor2
	CALL DELAY
	movlw .250
	movwf cuenta
	call incrementarcaja
	clrf PORTD
	CLRF PORTC
	return

pintar_valor3
	btfsc PORTB,1
	return
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo

	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	
	MOVLW	b'00000001'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO pintar_valor3
	CALL DELAY
	call incrementarcaja
	movlw .250
	movwf cuenta
	clrf PORTD
	CLRF PORTC
	return

pintar_valor4
	btfsc PORTB,1
	return
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; *****************************
	MOVLW	b'00001111'
	movwf	PORTC
	
	MOVLW	b'00100100'
	movwf	PORTD
	call retardo

	
	MOVLW	b'11100001'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo

	
	MOVLW	b'11101111'
	movwf	PORTC
	
	MOVLW	b'000111000'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO pintar_valor4
	call DELAY
	movlw .250
	movwf cuenta
	call incrementarcaja
	clrf PORTD
	CLRF PORTC
	return

pintar_valor5
	btfsc PORTB,1
	return
MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; ******************************************************************


	MOVLW	b'00001111'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	MOVLW	b'11110000'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	
	decfsz cuenta,1
	GOTO pintar_valor5
	CALL DELAY
	movlw .250
	movwf cuenta
	call incrementarcaja	
	clrf PORTD
	CLRF PORTC
	return

pintar_valor6
	btfsc PORTB,1
	return
	MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	; ****************************************************
	MOVLW	b'00000001'
	movwf	PORTC
	
	MOVLW	b'00100000'
	movwf	PORTD
	call retardo

	MOVLW	b'01101101'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	MOVLW	b'11110011'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	
	decfsz cuenta,1
	GOTO pintar_valor6
	call DELAY
	
	movlw .250
	movwf cuenta
	call incrementarcaja
	clrf PORTD
	CLRF PORTC
	return

pintar_valor7
	btfsc PORTB,1
	return
		MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo

	;; *******************************************
	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'00000100'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo

	decfsz cuenta,1
	GOTO pintar_valor7

	movlw .250
	movwf cuenta
	call incrementarcaja
	clrf PORTD
	CLRF PORTC
	return

pintar_valor8
	btfsc PORTB,1
	return
		MOVLW	b'11111110'
	movwf	PORTC
	
	MOVLW	b'01111110'
	movwf	PORTD
	call retardo

	MOVLW	b'10000001'
	movwf	PORTC
	
	MOVLW	b'01000010'
	movwf	PORTD
	call retardo
	MOVLW	b'01111111'
	movwf	PORTC
	
	MOVLW	b'10000001'
	movwf	PORTD
	call retardo
	;; ********************************
	MOVLW	b'00000000'
	movwf	PORTC
	
	MOVLW	b'00100100'
	movwf	PORTD
	call retardo

	MOVLW	b'01110010'
	movwf	PORTC
	
	MOVLW	b'00111100'
	movwf	PORTD
	call retardo
	
	decfsz cuenta,1
	GOTO pintar_valor8
	clrf PORTD
	CLRF PORTC
	movlw .250
	movwf cuenta
	clrf PORTD
	CLRF PORTC
	return
	

		;**************************************CAJAS 2********************************************************************
iterarCajas
		movlw .1
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde1
	
	movlw .2
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde2

	movlw .3
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde3
	
	movlw .4
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde4

	movlw .5
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde5
	
	movlw .6
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde6

	movlw .7
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde7
	
	movlw .8
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde8

	movlw .9
	subwf numCaja,0
	btfsc STATUS,Z
	call pintardesde9

	return	

				;**********************PINTADO ITERANDO**************************
pintardesde1
	return
pintardesde2
	return
pintardesde3
	return
pintardesde4
	return
pintardesde5
	return   
pintardesde6
	return   
pintardesde7
	return   
pintardesde8
	return   

end              	; End
