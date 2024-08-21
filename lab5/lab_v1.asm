            .ORIG       x800
            ; (1) Initialize interrupt vector table.
            LD          R0, VEC
            LD          R1, ISR
            STR         R1, R0, #0

            ; (2) Set bit 14 of KBSR.
            LDI         R0, KBSR
            LD          R1, MASK
            NOT         R1, R1
            AND         R0, R0, R1
            NOT         R1, R1
            ADD         R0, R0, R1
            STI         R0, KBSR

            ; (3) Set up system stack to enter user space.
            LD          R0, PSR
            ADD         R6, R6, #-1
            STR         R0, R6, #0
            LD          R0, PC
            ADD         R6, R6, #-1
            STR         R0, R6, #0
            ; Enter user space.
            RTI
VEC         .FILL       x0180
ISR         .FILL       x1000
KBSR        .FILL       xFE00
MASK        .FILL       x4000
PSR         .FILL       x8002
PC          .FILL       x3000
            .END

            .ORIG       x3000
            ; *** Begin user program code here ***
            LD          R0, ID
PUT         TRAP        x22
            JSR         DELAY
            BRnzp       PUT
            ; code of delay
DELAY       ST          R1, SaveR1
            LD          R1, COUNT
REP         ADD         R1, R1, #-1
            BRp         REP
            LD          R1, SaveR1
            RET
;
SaveR1      .BLKW       1
COUNT       .FILL       x2500
ID          .FILL       x3100
            .END
;
            .ORIG       x3100
            .STRINGZ    "PB2100024\n"
            .END
;
            .ORIG       x3200

HAN         ADD         R6, R6, #-1
            STR         R1, R6, #0
            
            ADD         R1, R0, #0
            BRZ         NO_RECURESE
            
            ADD         R6, R6, #-1
            STR         R7, R6, #0
            ADD         R6, R6, #-1
            STR         R0, R6, #0
            
            ADD         R0, R0, #-1
            JSR         HAN
            LDR         R1, R6, #0
            ADD         R6, R6, #1
            ADD         R0, R0, R0
            ADD         R0, R0, #1
            
            LDR         R7, R6, #0
            ADD         R6, R6, #1
NO_RECURESE LDR         R1, R6, #0
            ADD         R6, R6, #1
            RET
            .END
;
            .ORIG       x3300
OUTER       LDI         R0, H2
            LD          R1, A
            NOT         R1, R1
            ADD         R1, R1, #1;R1<-(-100)
            AND         R2, R2, #0
            ADD         R2, R2, #-10;R2<-(-10)
            AND         R3, R3, #0
HUN         ADD         R3, R3, #1
            ADD         R0, R0, R1;R0-100
            BRp         HUN
            BRn         GETL
            ST          R3, L
GETL        ADD         R3, R3, #-1
            ST          R3, L
            LD          R1, A
            ADD         R0, R0, R1;
;
            AND         R3, R3, #0
TEN         ADD         R3, R3, #1
            ADD         R0, R0, R2;R0-10
            BRp         TEN
            BRn         GETM
            ST          R3, M
GETM        ADD         R3, R3, #-1
            ST          R3, M
            ADD         R0, R0, #10
;
            ST          R0, N
;
            LD          R2, B
            LD          R1, L
            ADD         R1, R1, R2
            ST          R1, LL
            LD          R1, M
            ADD         R1, R1, R2
            ST          R1, MM
            ADD         R0, R0, R2
            ST          R0, NN
;            
            LD          R0, PRINT
            TRAP        x22
            RET
A           .FILL       #100
B           .FILL       x30
H2          .FILL       x4000
PRINT       .FILL       x3400
L           .BLKW       1
M           .BLKW       1
N           .BLKW       1
            .END
;
            .ORIG       x3400
            .FILL       x54;T
            .FILL       x6F;o
            .FILL       x77;w
            .FILL       x65;e
            .FILL       x72;r
            .FILL       x20;
            .FILL       x6F;o
            .FILL       x66;f
            .FILL       x20;
            .FILL       x68;h
            .FILL       x61;a
            .FILL       x6E;n
            .FILL       x6F;o
            .FILL       x69;i
            .FILL       x20;
            .FILL       x6E;n
            .FILL       x65;e
            .FILL       x65;e
            .FILL       x64;d
            .FILL       x73;s
            .FILL       x20;
LL          .BLKW       1
MM          .BLKW       1
NN          .BLKW       1
            .FILL       x20;
            .FILL       x6D;m
            .FILL       x6F;o
            .FILL       x76;v
            .FILL       x65;e
            .FILL       x73;s
            .FILL       x0A;\n
            .FILL       X0
            .END
;
            .ORIG       x3FFF
            ; *** Begin hanoi data here ***
HANOI_N     .FILL       xFFFF
H           .FILL       xFFFF;answer
            ; *** End hanoi data here ***
            .END

            .ORIG       x1000
            ; *** Begin interrupt service routine code here ***
            ST          R0, SR0
            ST          R1, SR1
            ST          R2, SR2
            ST          R3, SR3
            ST          R4, SR4
;
INPUT       TRAP        x23
;读入字符，检查是否在0-9之间
            LD          R1, BOT
            NOT         R1, R1
            ADD         R1, R1, #1
            ADD         R1, R0, R1;R0-x30
            BRn         PRINTNO;如果小于0打印�?
            LD          R1, TOP
            NOT         R1, R1
            ADD         R1, R1, #1
            ADD         R1, R0, R1;R0-x39
            BRp         PRINTNO;如果大于9打印�?
;
PRINTYES    LD          R1, BOT;否则打印正确
            NOT         R1, R1
            ADD         R1, R1, #1
            ADD         R1, R0, R1;ascii转二进制
            STI         R1, HANOI1;储存作为函数的输入参�?
            LDI         R0, HANOI1
            LD          R1, BOT
            ADD         R0, R0, R1
            TRAP        x21;回显
LOADYES     LD          R0, LIST2;加载字符�?
            TRAP        x22;输出字符
            LD          R1, HANO
            LDI         R0, HANOI1
            
            ST          R6, SR6
            LD          R6, STACK
            JSRR        R1;调用汉诺塔函数计�?
            STI         R0, H0
            LD          R0, OUTER0;将结果转换为ascii输出
            JSRR        R0
            RTI

            
;
PRINTNO     STI         R0, HANOI1
            LDI         R0, HANOI1
            TRAP        x21
            LD          R0, LIST1
LOADNO      TRAP        x22
;
            LD          R0, SR0
            LD          R1, SR1
            LD          R2, SR2
            LD          R3, SR3
            LD          R4, SR4
            LD          R6, SR6
            RTI
; *** End interrupt service routine code here ***
STACK       .FILL       xFDFF
H0          .FILL       x4000
OUTER0      .FILL       x3300
SR0         .BLKW       1
SR1         .BLKW       1
SR2         .BLKW       1
SR3         .BLKW       1
SR4         .BLKW       1
SR6         .BLKW       1
BOT         .FILL       x30
TOP         .FILL       x39
LIST1       .FILL       x1F00
LIST2       .FILL       x1E00
HANOI1      .FILL       x3FFF
HANO        .FILL       x3200
            .END
;
            .ORIG       x1F00
            .STRINGZ    " is not a decimal digit\n"
            .END
;
            .ORIG       X1E00
            .STRINGZ    " is a decimal digit\n"
            .END