
; Modified Trevor Douglas 2014\
\
;;; Directives
            PRESERVE8
            THUMB

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value\


;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0\
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8\
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register\
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register\
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register\
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register\
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register\
\
;PORT B GPIO - Base Addr: 0x40010C00
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0\
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8\
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register\
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register\
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register\
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register\
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register\
\
;The onboard LEDS are on port C bits 8 and 9\
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0\
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8\
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register\
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register\
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register\
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register\
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register\
\
;Registers for configuring and enabling the clocks\
;RCC Registers - Base Addr: 0x40021000\
RCC_CR		EQU		0x40021000	; Clock Control Register\
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register\
RCC_CIR		EQU		0x40021008	; Clock Interrupt Register\
RCC_APB2RSTR	EQU	0x4002100C	; APB2 Peripheral Reset Register\
RCC_APB1RSTR	EQU	0x40021010	; APB1 Peripheral Reset Register\
RCC_AHBENR	EQU		0x40021014	; AHB Peripheral Clock Enable Register\

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used\
\
RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register\
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register\
RCC_CSR		EQU		0x40021024	; Control/Status Register\
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2\
\
; Times for delay routines\
        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
			
            AREA    MYCODE, CODE, READONLY
			EXPORT	Reset_Handler
			ENTRY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;WHACK-A-MOLE GAME
;;CREATED BY: Daniel Takyi
;;Year: 2019
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Reset_Handler		PROC

 		BL GPIO_ClockInit
		BL GPIO_init



		ldr r6, = GPIOC_CRL
		ldr r0, = GPIOA_CRL
		ldr r8, = GPIOB_CRL
		ldr r5, = DELAYTIME

		
mainLoop
		lsr r5, #0x03
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Name: UC2
;;;
;;;Require:
;;;	R10: Used to see if a button has been pressed
;;;	R7: Used to store values to the LEDs
;;;	R4: Used to count out the delay time
;;;	
;;;Notes: This part of code cycles the LEDs until an input is read
;;;
UC2
;		add r12, #0x01
		
		bl checkIdr
		cmp r10, #0
		bne UC3		
			
		
		mov r4, #0x00
		mov r7, #0xEFFF
		str r7, [r0, #0x0C]		
led1
		add r4, #0x01
		cmp r4, r5
		bne led1
		
		
		
		bl checkIdr
		cmp r10, #0
		bne UC3
		
		
		mov r4, #0x00
		mov r7, #0xF7FF
		str r7, [r0, #0x0C]
led2	
		add r4, #0x01
		cmp r4, r5
		bne led2
		
		
		
		bl checkIdr
		cmp r10, #0
		bne UC3		
		
		
		mov r4, #0x00
		mov r7, #0xFBFF
		str r7, [r0, #0x0C]		
led3
		add r4, #0x01
		cmp r4, r5
		bne led3
		
		
		
		bl checkIdr
		cmp r10, #0
		bne UC3		
		
		
		mov r4, #0x00
		mov r7, #0xFDFF
		str r7, [r0, #0x0C]
led4
		add r4, #0x01
		cmp r4, r5
		bne led4



		b UC2

;;;;;;;;;;;;;;;;;;;;
;;;Name: UC3
;;;
;;;Require:
;;;	R4: Used to count out time
;;;	R7: Used to set success symbol on LEDS (when the right button is pushed)
;;;	R11: Used as the score count
;;;	R2, R1, R9: Used together to form a PRNG. R2 is the seed, R1 is the increment, R9 is the multiplier.
;;;				R2 is also used to flash the random LEDs
;;;
;;;Notes: This part of the code acts as the normal gameplay. One of the four LEDs popup and if you hit the proper
;;;		  button you will receive the success signal, if not you will lose the game and move to UC5
;;;
UC3
		
		lsl r5, #0x03
		mov r4, #0x00
		mov r7, #0xFFFF
		str r7, [r0, #0x0C]
		
		mov r11, #0x00	;score count
		
		push {r5}
;;;Adjust R5 in here to change PrelimWait
;
;
;;;
PrelimWait
		add r4, #0x01		
		cmp r4, r5
		bne PrelimWait
		pop {r5}
		
		mov r2, #73		;seed
		mov r1, #0x00	;increment
		push {r5}
loop
;;;Adjust the r11 comparison to change numCycles
		cmp r11, #0x0F
		beq win
		add r11, #1
		mov r9, #0x03
		mul r2, r9		;a*Xn
		add r2, r1		;+c
		and r2, #0x03	;mod m
		push {r2}

		add r1, #0x01
		
		cmp r2, #0
		bne notThird
		mov r2, #0x08
notThird
		cmp r2, #0x03
		bne notFourth
		mov r2, #0x04
notFourth

		lsl r2, #9
		
		mvn r2, r2
		str r2, [r0, #0x0C]
		mov r4, #0x00
show	
		
		bl checkIdr
		
		mvn r10, r10


		
		cmp r2, r10
		mvn r10, r10
		beq success		

		
		cmp r10, #0
		bne fail


		add r4, #0x04
		cmp r4, r5
		bne show

fail
		pop {r5, r2}
		sub r11, #0x01
		lsl r11, #9
		mvn r11, r11
		
		mov r2, #0x00
		mov r1, #0x07
		
		b UC5

success
		mov r7, #0xE1FF
		str r7, [r0, #0x0C]
		add r4, #0x01
		cmp r4, r5
		bne success
		
		pop {r2}	
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		sub r5, #0xFFF
		b loop
		
win 
		pop {r5}
		mov r2, #0x00
		mov r1, #0x07

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;Name: UC4
;;;
;;;Requires:
;;;	R7: Used to store values at the ODR of the LEDs
;;;	R4:	Used to count how long an LED is flashed for
;;;	R2:	Used to as a psuedo WinningSignalTime; It counts how many times the leds have flashed,
;;;		and then forces a return to UC2 when it reaches a R1's value
;;;	R1: Is the count amount that R2 counts too; Its value is set up right above
;;;
;;;Notes: This part of the code's job is to display the winning signal and then return to the waiting to play state
;;;
;;;
UC4

		mov r7, #0xEDFF
		str r7, [r0, #0x0C]
		mov r4, #0x00
first
		add r4, #0x02
		cmp r4, r5
		bne first
		
		
		mov r7, #0xF3FF
		str r7, [r0, #0x0C]
		mov r4, #0x00
second
		add r4, #0x02
		cmp r4, r5
		bne second
		
		cmp r2, r1
		beq mainLoop
		add r2, #0x01
		
		b UC4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;Name: UC5
;;;
;;;Requires:
;;;	R11: Used to store the score in binary at the ODR of the LEDs
;;;	R4:	Used to count how long an LED is flashed for
;;;	R2:	Used to as a psuedo WinningSignalTime; It counts how many times the leds have flashed,
;;;		and then forces a return to UC2 when it reaches a R1's value
;;;	R1: Is the count amount that R2 counts too; Its value is set up right above
;;;	R7: Used to reset the LEDs for the moment they turn off in a flash
;;;
;;;Notes: This part of the code's job is to display the player's score and then return to the waiting to play state
;;;
;;;
UC5

		str r11, [r0, #0x0C]
		mov r4, #0x00
firstL
		add r4, #0x02
		cmp r4, r5
		bne firstL
		
		
		mov r7, #0xFFFF
		str r7, [r0, #0x0C]
		mov r4, #0x00
secondL
		add r4, #0x02
		cmp r4, r5
		bne secondL
		
		cmp r2, r1
		beq mainLoop
		add r2, #0x01		
		
		b UC5



		B	mainLoop
		ENDP




;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\



;This routine will enable the clock for the Ports that you need
	ALIGN
GPIO_ClockInit PROC\

	; Students to write.  Registers   .. RCC_APB2ENR\
	; ENEL 384 Pushbuttons: SW2(Red): PB8, SW3(Black): PB9, SW4(Blue): PC12 *****NEW for 2015**** SW5(Green): PA5\
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12\

	push{r4, r5}
	
	ldr r4, = RCC_APB2ENR
	mov32 r5, #0x0000001C
	str r5, [r4]
	
	pop{r4, r5}



	BX LR
	ENDP
		
	
	
;This routine enables the GPIO for the LED's.  By default the I/O lines are input so we only need to configure for ouptut.\
	ALIGN
GPIO_init  PROC
	
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12\

	ldr r2, = GPIOA_CRL
	ldr r3, = GPIOB_CRL
	ldr r0, = GPIOC_CRL
	mov32 r1, #0x44433334
	str r1, [r2, #0x04]
	mov32 r1, #0x44444444
	str r1, [r3, #0x00]	
	mov32 r1, #0x44444433
	str r1, [r0, #0x04]

    BX LR
	ENDP
		


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;Name: checkIDR
;;;
;;;Returns:
;;;	R10: This return value holds the 1's complement of the IDR
;;;
;;;
;;;Notes: This subroutine is used to detect the state of the push buttons. It can be classified as
;;;		  a helper function, as it is used in multiple user cases
;;;
	ALIGN
checkIdr  PROC
	
	

		ldr r10, [r6, #0x08]
		and r10, #0xFFFFFFFF
		mvn r10, r10	
		lsr r10, #1
		and r10, #0x0800
		mov r9, r10


		ldr r10, [r0, #0x08]
		and r10, #0xFFFFFFFF
		mvn r10, r10
		lsl r10, #7
		and r10, #0x1000
		orr r9, r10
			
		
		ldr r10, [r8, #0x08]
		and r10, #0xFFFFFFFF
		mvn r10, r10
		lsl r10, #1
		and r10,#0x0600
		orr r10, r9

    BX LR
	ENDP
		
		
		




	ALIGN
		
		
	END
