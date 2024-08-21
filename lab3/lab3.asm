.ORIG	x3000
    LDI     R0, NUM  
    LD      R1, DATA       ; R1 is the opinter of the string
    AND     R2, R2, #0
    AND     R5, R5, #0

    LDR     R4, R1, #0     ; R4 <- mem[R1]
    ADD     R1, R1, #1     ; pointer++
    NOT	    R4,	R4      
    ADD     R4, R4, #1     ; 取 R4 的补码
    ADD     R0, R0, #-1     

LOOP LDR    R3, R1, #0     ; R3 <- 读入一个字符
     ADD    R1, R1, #1     ; pointer++
     ADD    R7, R3, R4     ; R7 <- now - last
     BRnp   PUT0           ; if(now != last) goto PUT0
     ADD    R5, R5, #1     ; if(now == last) num_cnt++
     NOT    R6, R5
     ADD    R6, R6, #1     ; R6 <- num_cnt 的二进制补码
     ADD    R7, R2, R6     ; R7 <- ans - num_cnt
     BRzp   NEXT           ; if(ans >= num_cnt) goto NEXT
     ADD    R2, R5, #0     ; if(ans < num_cnt) ans <- num_cnt
     BR NEXT
PUT0 AND    R5, R5, #0     ; R5 <- 0

NEXT NOT    R4, R3
     ADD    R4, R4, #1     ; R4 <- R3 的补码
     ADD    R0, R0, #-1    ; cnt--
     BRz    STOP           ; if(cnt == 0), goto STOP
     BR     LOOP

STOP ADD R2, R2, #1 
     STI R2, RESULT

    HALT    

    RESULT  .FILL	x3050
    NUM     .FILL	x3100
    DATA    .FILL	x3101
.END