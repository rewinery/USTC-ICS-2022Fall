.ORIG x800
        ; (1) Initialize interrupt vector table.
        LD  R0, VEC
        LD  R1, ISR
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR.
        LDI R0, KBSRR
        LD  R1, MASK
        NOT R1, R1
        AND R0, R0, R1
        NOT R1, R1
        ADD R0, R0, R1
        STI R0, KBSRR

        ; (3) Set up system stack to enter user space.
        LD  R0, PSR
        ADD R6, R6, #-1
        STR R0, R6, #0
        LD  R0, PC
        ADD R6, R6, #-1
        STR R0, R6, #0
        ; Enter user space.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1000
KBSRR   .FILL xFE00
MASK    .FILL x4000
PSR     .FILL x8002
PC      .FILL x3000
        .END

; *** USER PROGRAM ***
        .ORIG x3000
LOOP    LEA R0, STUID
        TRAP x22
DELAY   ST R1, SaveR1   ; store R1 first
        LD R1, COUNT
REP     ADD R1, R1, #-1
        BRp REP
        LD R1, SaveR1   ; restore R1
        BRnzp LOOP
SaveR1  .BLKW 1
COUNT   .FILL x2500      
STUID   .STRINGZ "PB21000009\n"
        .END

        .ORIG x3100
        
HANOI   ADD R6, R6, #-1 ; R6--
        STR R1, R6, #0  ; mem[R6] <- R1
        ADD R1, R0, #0  ; R1 <- R0
        BRz EXIT        
        ADD R6, R6, #-1 ; R6--
        STR R7, R6, #0  ; mem[R6] <- R7
        ADD R6, R6, #-1 ; R6--
        STR R0, R6, #0  ; mem[R6] <- R0
        ADD R0, R0, #-1 ; R0--
        JSR HANOI       
        LDR R1, R6, #0  ; R1 <- mem[R0]
        ADD R6, R6, #1  ; R6++
        ADD R0, R0, R0  
        ADD R0, R0, #1  ; R0 <- 2*R0+1
        LDR R7, R6, #0  ; R7 <- mem[R6]
        ADD R6, R6, #1  ; R6++
EXIT    LDR R1, R6, #0  ; R1 <- mem[R6]
        ADD R6, R6, #1  ; R6++
        RET
        .END
;
        .ORIG x3200
        LEA R0, SET1
        TRAP x22
;
        LDI R1, RESULTP ; R1 is the result
        LD  R3, NUMB0   ; R3 <- x30
        AND R5, R5, #0  ; R5 <- 0
        LD  R4, HUND    
        NOT R4, R4  
        ADD R4, R4, #1  ; R4 <- (-100)
GETH    ADD R1, R1, R4  ; R1 -= 100
        BRn FH          ; if(R1 < 0) goto FH(finish calculating hundred bit)
        ADD R5, R5, #1  ; COUNT++
        BRnzp   GETH
;
FH      ADD R5, R5, R3  ; To change to ASCII code
        LD  R4, HUND    ; R4 <- 100
LOOPP   LDI R2, DSRR    
        BRzp LOOPP
        STI R5, DDRR    ; To present 'bai wei'
        ADD R1, R1, R4  ; R1 += 100
        LD  R4, TEN     
        NOT R4, R4
        ADD R4, R4, #1  ; R4 <- (-10)
        AND R5, R5, #0  ; COUNT <- 0
GETT    ADD R1, R1, R4
        BRn FT
        ADD R5, R5, #1
        BRnzp GETT

FT      ADD R5, R5, R3
        LD  R4, HUND
LOOPP2  LDI R2, DSRR
        BRzp LOOPP2
        STI R5, DDRR  

GET1    LD R4, TEN
        ADD R5, R1, R4
        ADD R5, R5, R3
LOOPP3  LDI R2, DSRR
        BRzp LOOPP3
        STI R5, DDRR

        LEA R0, SET2
        TRAP x22
        LD R1, SR1
        RET
SR1     .BLKW 1
DSRR    .FILL xFE04
DDRR    .FILL xFE06
NUMB0   .FILL x30
HUND    .FILL #100
TEN     .FILL #10
SET1    .STRINGZ "Tower of hanoi needs "
SET2    .STRINGZ " moves.\n"
RESULTP .FILL x4000
        .END

        .ORIG x3FFF
        ; *** Begin hanoi data here ***
HANOI_N .FILL xFFFF
H       .FILL xFFFF
        ; *** End hanoi data here ***
        .END


; *** INTERRUPT  SERVICE ***
        .ORIG x1000
        ADD R6, R6, #-1
        STR R0, R6, #0
        ADD R6, R6, #-1
        STR R1, R6, #0
        ADD R6, R6, #-1
        STR R2, R6, #0
        ADD R6, R6, #-1
        STR R3, R6, #0

LOOP1   LDI R1, KBSR
        BRzp LOOP1
;
        LDI R0, KBDR    ; Read from keyboard
LOOP2   LDI R1, DSR     ; State of output
        BRzp LOOP2 
        STI R0, DDR     
        LD  R2, N0 
        ADD R2, R2, R0  
        BRn NOTN
        LD  R2, N9
        ADD R2, R2, R0
        BRp NOTN
        
;
        LD  R2, N0      ; R2 <- (-48)
        ADD R0, R0, R2  ; Transfer R0 from ASCII to number n
        STI R0, SAR0    ; Store n in x3FFF
        LD  R2, NUMSTR2
        LEA R3, STR2
LOOP3   LDI R1, DSR
        BRzp LOOP3
        LDR R0, R3, #0
        STI R0, DDR
        ADD R3, R3, #1
        ADD R2, R2, #-1
        BRp LOOP3
;
        LDI R0, SAR0
        ST  R6, SAR6    ; Store R6
        LD  R6, STACK
        LD  R1, HANOII  ; Begin hanoi program
        JSRR R1
        STI R0, SRESULT ; Store the result in x4000
        LD  R1, OUTPUT  ; Begin output program
        JSRR R1
        LD R6, SAR6     ; restore R6
        BRnzp   DONE

NOTN    LD  R2, NUMSTR3
        LEA R3, STR3
LOOP4   LDI R1, DSR
        BRzp LOOP4
        LDR R0, R3, #0
        STI R0, DDR
        ADD R3, R3, #1
        ADD R2, R2, #-1
        BRp LOOP4

DONE    LDR R3, R6, #0
        ADD R6, R6, #1
        LDR R2, R6, #0
        ADD R6, R6, #1
        LDR R1, R6, #0
        ADD R6, R6, #1
        LDR R0, R6, #0
        ADD R6, R6, #1
        RTI

STACK   .FILL xFDFF
HANOII  .FILL x3100
OUTPUT  .FILL x3200
KBSR    .FILL xFE00
KBDR    .FILL xFE02
DSR     .FILL xFE04
DDR     .FILL xFE06
N0      .FILL #-48
N9      .FILL #-57
SAR6    .BLKW 1
SAR0    .FILL x3FFF
SRESULT .FILL x4000
NUMSTR2 .FILL 21
STR2    .STRINGZ " is a decimal digit.\n"
NUMSTR3 .FILL 25
STR3    .STRINGZ " is not a decimal digit.\n"
        .END