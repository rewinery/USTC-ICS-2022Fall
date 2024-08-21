.ORIG	x3000
        AND R1, R1, #0
        ADD R1, R1, #15
        AND R7, R7, #0

LOOP    LD R0, DATA     ; R0 是指针
        AND R2, R2, #0  ; 用 R2 记录每一次循环中的最大值
        NOT R4, R2
        ADD R4, R4, #1
        ADD R7, R7, #15 ; 
        ADD R7, R7, #1  ; R7 <- 15

SUBLOOP LDR R3, R0, #0
        ADD R5, R4, R3
        BRnz VALT       ; if(R3 <= R2)   goto 'VALT'
        ADD R2, R3, #0  ; if(R3 > R2)   R3 <- R2
        NOT R4, R2
        ADD R4, R4, #1  ; 重新对 R2 求补码     
        ADD R6, R0, #0  ; R6 记录下当前最大值的地址   

VALT    ADD R0, R0, #1  ; 指针增加
        ADD R7, R7, #-1  ; 小循环减少一次
        BRzp SUBLOOP     ; 小循环执行 16 次，找出当前最大的一个数字， if(R7 >= 0) goto SUBLOOP
        
        LD R4, RESULT   ; 
        ADD R4, R4, R1
        STR R2, R4, #0  ; R4 临时用于存放位置
        STR R7, R6, #0  ; 将已经用过的当前循环中最大的值标记为 0

        ADD R1, R1, #-1 ; 大循环计数减少一次
        BRzp LOOP       ; if(R1 >= 0) goto LOOP
        
        AND R0, R0, #0
        AND R1, R1, #0
        AND R2, R2, #0
        LD R3, RESULTA
        LD R4, RESULT   ; 指针
        ADD R4, R4, #15
        ADD R1, R1, #4  ; 4 个有可能优秀的人
        LD	R7,	GETA
        NOT R7, R7
        ADD R7, R7, #1  ; 取 -85 的补码
STATA   LDR R5, R4, #0  ; 从排序过的数据中读取
        ADD R5, R5, R7
        BRn ENDA        ; if(score < 85) goto ENDA
        ADD R2, R2, #1  ; R2++
        ADD R4, R4, #-1 ; R4--
        ADD R1, R1, #-1 ; R1--
        BRp STATA
ENDA    STR R2, R3, #0  ; 存储数据
        ADD R1, R1, #4

        AND R2, R2, #0
        LD	R7,	GETB
        NOT R7, R7
        ADD R7, R7, #1  ; 取 -75 的补码
STATB   LDR R5, R4, #0  ; 从排序过的数据中读取
        ADD R5, R5, R7
        BRn ENDB        ; if(score < 75) goto ENDB
        ADD R2, R2, #1  ; R2++
        ADD R4, R4, #-1 ; R4--
        ADD R1, R1, #-1 ; R1--
        BRp STATB
ENDB    STR R2, R3, #1  ; 存储数据
        ADD R1, R1, #4
        HALT



INF     .FILL	x7FFF

GETA    .FILL	#85
GETB    .FILL	#75

DATA    .FILL	x4000 ; 数据指针
RESULT  .FILL	x5000 ; 存储排名后的成绩
RESULTA .FILL	x5100 ; 存储 A 和 B
.END