DATAS SEGMENT
    ;�˴��������ݶδ���  
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
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    ;�س������ӳ���
    CR PROC
    	MOV AH,2
        MOV DL,13
        INT 21H
        MOV DL,10
        INT 21H
        RET
    CR ENDP
    ;����ʮ����������(Сд)�ӳ���
    INPUT_16 PROC
    	PUSH AX
    	PUSH CX
    	MOV BX,0
      NEWCHAR:
    	MOV AH,1
    	INT 21H
    	SUB AL,30H
    	JL EXIT       ;<0�˳�
    	CMP AL,10
    	JL ADD_TO     ;0<AL<10
    	SUB AL,27H    ;ת����Сд
    	CMP AL,0aH    
    	JL EXIT       ;<a�˳�
    	CMP AL,10H
    	JGE EXIT      ;>f�˳�
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
    ;�˴��������δ���
    ;����x
    PUSH AX         ;����ax
    LEA DX,OUTP1
    MOV AH,09H      ;�ַ����
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[X],BX
    CALL CR
    
    ;����y
    PUSH AX         ;����ax
    LEA DX,OUTP2
    MOV AH,09H      ;�ַ����
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[Y],BX
    CALL CR
    
    ;����z
    PUSH AX         ;����ax
    LEA DX,OUTP3
    MOV AH,09H      ;�ַ����
    INT 21H
    POP AX
    CALL INPUT_16
    MOV WORD PTR[Z],BX
    CALL CR
    
    MOV AX,WORD PTR [X]    ;AX�ŵ�λ
    MOV DX,WORD PTR [X+2]  ;DX�Ÿ�λ
    ADD AX,WORD PTR [Y]    ;��λ��
    ADC DX,WORD PTR [Y+2]  ;��λ��
    ADD AX,24
    ADC DX,0
    SUB AX,WORD PTR [Z]    ;��λ��
    SBB DX,WORD PTR [Z+2]  ;��λ��
    MOV WORD PTR [W],AX    ;��λ��W
    MOV WORD PTR [W+2],DX  ;��λ��W+2
    
    ;���W
    PUSH AX
    LEA DX,OUTP4
    MOV AH,09H
    INT 21H
    POP AX
    
    ;��ʮ��λ
    MOV BX,WORD PTR[W+2]
    MOV CH,4         ;����ѭ������
  ROTATE:            
    MOV CL,4         ;BXѭ��������λ���Ѹ���λ��������λ    
    ROL BX,CL      
    MOV AL,BL
    AND AL,0FH
    ADD AL,30H       ;AL�е���ֵת��Ϊascll��
    CMP AL,3AH       ;0~9:30h~39h
    JL PRINT
    ADD AL,7H
  PRINT:             ;���ŵ��ã�����
    MOV DL,AL
    MOV AH,2
    INT 21H
    DEC CH
    JNZ ROTATE
    
    ;��ʮ��λ
    MOV BX,WORD PTR[W]
    MOV CH,4
  ROTATE1:             
    MOV CL,4         ;BXѭ��������λ���Ѹ���λ��������λ    
    ROL BX,CL      
    MOV AL,BL
    AND AL,0FH
    ADD AL,30H       ;AL�е���ֵת��Ϊascll��
    CMP AL,3AH       ;0~9:30h~39h
    JL PRINT1
    ADD AL,7H
  PRINT1:             ;���ŵ��ã�����
    MOV DL,AL
    MOV AH,2
    INT 21H
    DEC CH
    JNZ ROTATE1  
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




