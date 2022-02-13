DATAS SEGMENT
    ;此处输入数据段代码  
    remind1 db 'Please input the first num:','$'
    remind2 db 'Please input the second num:','$'
    remind3 db 'Please input the third num:','$'
    remind4 db 'the result is:','$'
    
    xbuffer db 9
    		db 0
    		db 9 dup(0)
    		
   	ybuffer db 9
   			db 0
   			db 9 dup(0)
   			
   	zbuffer db 9
   			db 0
   			db 9 dup(0)
    
   	x dd ?
	y dd ?
	z dd ?
	result dd ?
    ;x dd 00000001h
    ;y dd 00000001h;本人学号后八位
    ;z dd 24
    ;w dd 0;占位
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    
    huanhang macro
	mov ah,02h
	mov dl,0dh
	INT 21H                              ; 换行
	mov ah,02h
	mov dl,0ah
	INT 21H
	ENDM

	output      macro  string
	mov AH,09h                             ; 打印字符串
	mov DX,OFFSET  string
	INT 21H
	ENDM
	
	input       macro  instring
	mov AH,10
	mov DX,OFFSET  instring                  ;输入字符串
	INT 21H
	ENDM
	
input_n proc
	push ax
	push cx
	mov bx,0
jud:
    mov al,[si]    
	sub al,30h
	cmp al,0
	jl exit ;小于不满足要求	
juda:
	cmp al,10
	jl jud10;0-9
	sub al,27h
	cmp al,0ah
	jl exit ;<a
	cmp al,10h;>f
	jge exit
jud10:
	mov cl,4
	shl bx,cl	
	mov ah,0
	add bx,ax
exit:
	pop cx
	pop ax
	ret
input_n endp
    
START:
    MOV AX,DATAS
    MOV DS,AX
    

    
    ;此处输入代码段代码
    ;输入x
    push ax
    output remind1
    pop ax
    input xbuffer
    mov si,offset[xbuffer+2]
    mov cx,0
    mov cl,[xbuffer+1]
loop1:
	call input_n
	inc si
	loop loop1
    
    mov word ptr[x],bx
    huanhang
    
    push ax
    output remind2
    pop ax
    input ybuffer
    mov si,offset[ybuffer+2]
    mov cx,0
    mov cl,[ybuffer+1]
loop2:
	call input_n
	inc si
	loop loop2
    mov word ptr[y],bx
    huanhang
    
    push ax
    output remind3
    pop ax
    input zbuffer
    mov si,offset[zbuffer+2]
    mov cx,0
    mov cl,[zbuffer+1]
loop3:
	call input_n
	inc si
	loop loop3
	
    mov word ptr[z],bx
    huanhang
    
	mov ax,word ptr[x]
	mov dx,word ptr[x+2]
	add ax,word ptr[y]
	adc dx,word ptr[y+2]
	add ax,24
	add dx,0
	sub ax,word ptr[z]
	sbb dx,word ptr[z+2]
	mov word ptr[result],ax
	mov word ptr[result+2],dx
	
	output remind4
	huanhang
	
	

	
	
	;高十六位
    MOV bx,word ptr[result+2]
    MOV ch,4         ;设置循环次数
  ROTATE:            
    MOV CL,4         ;BX循环左移四位，把高四位移至低四位    
    rol BX,CL      
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
    MOV BX,WORD PTR[result]
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











