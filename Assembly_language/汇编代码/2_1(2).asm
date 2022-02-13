DATAS SEGMENT
    ;此处输入数据段代码  
    OUTP1 DB 'Please Input X:','$'
    OUTP2 DB 'Please Input Y:','$'
    OUTP3 DB 'Please Input Z:','$'
    OUTP4 DB 'W:','$'
    X DD 1
    Y DD 1
    Z DD 1
    W DD ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    ;回车换行子程序
    CR PROC
    	MOV AH,2
        MOV DL,13
        INT 21H
        MOV DL,10
        INT 21H
        RET
    CR ENDP
    ;输入十六进制数据(小写)子程序
    INPUT_16 PROC
    	PUSH AX
    	PUSH CX
    	MOV BX,0
      NEWCHAR:
    	MOV AH,1
    	INT 21H
    	SUB AL,30H
    	JL EXIT       ;<0退出
    	CMP AL,10
    	JL ADD_TO     ;0<AL<10
    	SUB AL,27H    ;转化成小写
    	CMP AL,0aH    
    	JL EXIT       ;<a退出
    	CMP AL,10H
    	JGE EXIT      ;>f退出
   	  ADD_TO:
   	    MOV CL,4
   	    SHL BX,CL
   	    MOV AH,0
   	    ADD BX,AX
   	    JMP NEWCHAR
   	  EXIT:
   	    POP CX
   	    POP AX
   	    RET
   	INPUT_16 ENDP
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    ;输入x
    PUSH AX         ;保护ax
    LEA DX,OUTP1
    MOV AH,09H      ;字符输出
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[X],BX
    CALL CR
    
    ;输入y
    PUSH AX         ;保护ax
    LEA DX,OUTP2
    MOV AH,09H      ;字符输出
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[Y],BX
    CALL CR
    
    ;输入z
    PUSH AX         ;保护ax
    LEA DX,OUTP3
    MOV AH,09H      ;字符输出
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[Z],BX
    CALL CR
    
    MOV AX,WORD PTR [X]    ;AX放低位
    MOV DX,WORD PTR [X+2]  ;DX放高位
    ADD AX,WORD PTR [Y]    ;低位加
    ADC DX,WORD PTR [Y+2]  ;高位加
    ADD AX,24
    ADC DX,0
    SUB AX,WORD PTR [Z]    ;低位减
    SBB DX,WORD PTR [Z+2]  ;高位减
    MOV WORD PTR [W],AX    ;低位放W
    MOV WORD PTR [W+2],DX  ;高位放W+2
    
    ;输出W
    PUSH AX
    LEA DX,OUTP4
    MOV AH,09H
    INT 21H
    POP AX
    
    ;高十六位
    MOV BX,WORD PTR[W+2]
    MOV CH,4         ;设置循环次数
  ROTATE:            
    MOV CL,4         ;BX循环左移四位，把高四位移至低四位    
    ROL BX,CL      
    MOV AL,BL
    AND AL,0FH
    ADD AL,30H       ;AL中的真值转换为ascll码
    CMP AL,3AH       ;0~9:30h~39h
    JL PRINT
    ADD AL,7H
  PRINT:             ;二号调用，屏显
    MOV DL,AL
    MOV AH,2
    INT 21H
    DEC CH
    JNZ ROTATE
    
    ;低十六位
    MOV BX,WORD PTR[W]
    MOV CH,4
  ROTATE1:             
    MOV CL,4         ;BX循环左移四位，把高四位移至低四位    
    ROL BX,CL      
    MOV AL,BL
    AND AL,0FH
    ADD AL,30H       ;AL中的真值转换为ascll码
    CMP AL,3AH       ;0~9:30h~39h
    JL PRINT1
    ADD AL,7H
  PRINT1:             ;二号调用，屏显
    MOV DL,AL
    MOV AH,2
    INT 21H
    DEC CH
    JNZ ROTATE1  
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




