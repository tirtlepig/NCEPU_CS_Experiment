DATAS SEGMENT
    ;此处输入数据段代码  
    remind1 db 'Match!',0dh,0ah,'$'
    remind2 db 'NO Match',0dh,0ah,'$'
    remind3 db 'Please input one sentence:','$'
    remind4 db 'Please input your key word:','$'
    remind5 db 'The location is:','$'
    remind6 db 'H of this sentence',0dh,0ah,'$'
    remind7 db 'The deleted sentence is:',0dh,0ah,'$'
    key db 100,?,100 DUP(0)
   	sentence db 100,?,100 DUP(0);长度均不超过100
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov es,ax;数据段附加段同处一个逻辑段
    
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
    
    ;此处输入代码段代码
	
    
again1:
    output remind3
    input sentence
    huanhang
    
    output remind4
    input key
    huanhang
    
	mov cl,[key+1]
	lea si,[key+2]        ;si为key的头指针
	lea di,[sentence+2]        ;di为sentence的头指针
	mov bl,[sentence+1]
	sub bl,cl
	inc bl                   ;bl从前面的字符开始比较不相等时比较的循环次数，bl = sentence – key + 1
again2:
	mov cl,[key+1]       ;cx为keyword的长度
	and cx,0ffh          ;高位置零
	push si                  ;si入栈
	push di                  ;di入栈
	cld                      ;复位方向标志
	repz cmpsb
	jz match                 ;循环比较字符串，相同了转移至match
	pop di                   ;di出栈
	pop si                   ;si出栈
	inc di                   ;di+1
	dec bl                    ;bl-1
	jnz again2
	output remind2              ;输出no match
	jmp again1
match:
	output remind1
	output remind5
	pop di
	pop si
	mov ax,di
	sub ax,offset[sentence+2]
	push ax
	mov cl,4                   	;长度均限定为100，所以只需计算两位即可
	rol al,cl                   ;计算第一位
	and al,0fh					;只保留低四位
	add al,30h
	cmp al,39h					
	jbe next1					
	add al,07h					;不是0-9 再加07h

next1:
	mov dl,al                 ;输出第一位
	mov ah,02h
	int 21h
	pop ax
	and al,0fh                 ;计算第二位
	add al,30h
	cmp al,39h
	jbe next2
	add al,07h
next2:
	mov dl,al                  ;输出第二位
	mov ah,02h
	int 21h
	output remind6
	mov ax,di
	mov bl,[key+1]
	mov bh,0h
	add bx,di
	push bx;保存di新的开始位置
	sub bx,offset[sentence+2]
	mov cl,[sentence+1]
	mov ch,0h
	sub cx,bx
	mov bx,cx
	sub ax,offset[sentence+2]
	mov cx,ax
	lea di,[sentence+2]
	output remind7
loop1:
	mov dl,[di]
	mov ah,02h
	int 21h
	inc di
	loop loop1
	
	mov cx,bx
	pop bx
	
loop2:
	mov dl,[bx]
	mov ah,02h
	int 21h
	inc bx
	loop loop2
	huanhang
	jmp again1

	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START




