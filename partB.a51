; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

ORG 000BH
CPL P0.7
CLR TR0
RETI

ORG 001BH
CLR TR1
RETI

start:
SETB EA
SETB ET0
SETB ET1
MOV TMOD, #11H

;----State-0----

      acall delay
	  acall delay
	  acall lcd_init      ;initialise LCD
	  acall delay
	  acall delay
	  acall delay
	  mov a,#80h		 ;Put cursor on first row,0 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1_s0   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  mov a,#0C0h		  ;Put cursor on second row,0 column
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2_s0
	  acall lcd_sendstring
	  
;---------------
mainLoop:

;----State-1----

	  MOV R0, #75
	  x1: CALL loadT1for10ms
	  SETB TR1
	  y1: JB TR1, z1
	  DJNZ R0, x1
	  LJMP next1
	  z1: JB TR0, y1
	  CALL loadN1
	  LJMP y1
	  next1:
	  
;----State-2----

	  MOV R0, #75
	  x2: CALL loadT1for10ms
	  SETB TR1
	  y2: JB TR1, z2
	  DJNZ R0, x2
	  LJMP next2
	  z2: JB TR0, y2
	  CALL loadN2
	  LJMP y2
	  next2:
	  
;----State-3----

	  MOV R0, #75
	  x3: CALL loadT1for10ms
	  SETB TR1
	  y3: JB TR1, z3
	  DJNZ R0, x3
	  LJMP next3
	  z3: JB TR0, y3
	  CALL loadN3
	  LJMP y3
	  next3:
	  
;----State-4----

	  MOV R0, #75
	  x4: CALL loadT1for10ms
	  SETB TR1
	  y4: JB TR1, z4
	  DJNZ R0, x4
	  LJMP next4
	  z4: JB TR0, y4
	  CALL loadN2
	  LJMP y4
	  next4:
	  
;----State-5----

	  MOV R0, #100
	  x5: CALL loadT1for10ms
	  SETB TR1
	  y5: JB TR1, z5
	  DJNZ R0, x5
	  LJMP next5
	  z5: JB TR0, y5
	  CALL loadN4
	  LJMP y5
	  next5:
	  
;----State-6----
	  CLR TR0
	  CLR P0.7
	  MOV R0, #50
	  x6: CALL loadT1for10ms
	  SETB TR1
	  y6: JB TR1, y6
	  DJNZ R0, x6
	  next6:
	  
;----State-7----

	  MOV R0, #100
	  x7: CALL loadT1for10ms
	  SETB TR1
	  y7: JB TR1, z7
	  DJNZ R0, x7
	  LJMP next7
	  z7: JB TR0, y7
	  CALL loadN4
	  LJMP y7
	  next7:
	  
;----State-8----

	  MOV R0, #100
	  x8: CALL loadT1for10ms
	  SETB TR1
	  y8: JB TR1, z8
	  DJNZ R0, x8
	  LJMP next8
	  z8: JB TR0, y8
	  CALL loadN5
	  LJMP y8
	  next8:
	  LJMP mainLoop
	
loadT1for10ms:
MOV TH1, #0B1H
MOV TL1, #0E0H
RET

loadN1:
MOV TH0, #0EEH
MOV TL0, #3FH
SETB TR0
RET

loadN2:
MOV TH0, #0F0H
MOV TL0, #30H
SETB TR0
RET

loadN3:
MOV TH0, #0F2H
MOV TL0, #0B7H
SETB TR0
RET

loadN4:
MOV TH0, #0F5H
MOV TL0, #72H
SETB TR0
RET

loadN5:
MOV TH0, #0F4H
MOV TL0, #2AH
SETB TR0
RET
	

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 1000h
my_string1_s0:
         DB   "  ROLLING TIME  ", 00H
my_string2_s0:
		 DB   "                ", 00H		 
			
end
	