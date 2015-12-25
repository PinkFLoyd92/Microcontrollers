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
	unidades	;registro de unidades
	uni_cod	;Código de 7 segmentos de unidades

	ENDC
	;************************START OF PROGRAM ***********************			     ; forma de iniciar programa que usa interrupciones	
	
	org		0x00		; vector de reset
	goto	main			; salto a "main"
	org		0x04        	; vector de interrupción  
	goto	INTERRUPCION 		; salto a interrupción
	org		0x05  		; continuación de programa

;************************ MAIN PROGRAM *************************
; inicio de programa principal
;***************************************************************
;SETEO DE PUERTOS Y REGISTROS       	

main  
	banksel	TRISA		;Selects bank containing register TRISA
	clrf	TRISA		;All port A pins are configured as outputs                 
	clrf	TRISC		;All port c pins are configured as outputs                 
	clrf	TRISD		;All port d pins are configured as outputs                 
	clrf	TRISE		;All port e pins are configured as outputs                 
	movlw	b'00011111'
	movwf	TRISB		;RB5 ,RB6 y RB7 configured as outputs        
	banksel	ANSEL		;Bank containing register ANSEL
	clrf	ANSEL		;Clears registers ANSEL and ANSELH
	clrf	ANSELH		;All pins are digital

;*********seteo_todas_la_salidas********************************	
	banksel	PORTA
	clrf	PORTA
	clrf	PORTC
	clrf	PORTD
	clrf	PORTE
	clrf	PORTB	

	;; TIMER0 USADO PARA CREAR TEMPORIZACION DE 5 SEGUNDOS
;*********temporizacion_timers**********************************

	BANKSEL TMR0 ;
	CLRWDT 			;Clear WDT
	CLRF TMR0 		;Clear TMR0 
	BANKSEL OPTION_REG 	;Seleccionar registro option_reg
	BSF OPTION_REG,PSA ;Select WDT
	BSF OPTION_REG,TOCS ;RA4 tocki pin
	CLRF TMR0 		;Clear TMR0 

;;****************INTERRUPCION*******************************
INTERRUPCION
	
	retfie	


;;------------MAIN******************************************** 
	lazo
		nop
		goto lazo
	
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
