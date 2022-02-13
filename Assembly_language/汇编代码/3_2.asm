DATAS SEGMENT
    ;此处输入数据段代码 
    letternum db 0;字母个数
    digitnum db 0;数字个数
    othernum db 0;其它字符个数
    
    inputstring db 'Please input one string:','$';提醒输入
    ;以下是输出提示
    outputofletter db 0dh,0ah,'The number of letter is:','$';字母个数
    outputofdigit db 0dh,0ah,'The number of digit is:','$';数字个数
    outputofother db 0dh,0ah,'The number of other is:','$';其它字符个数
    
    stringbuffer db 80;字符串缓冲区
    			 db 0
    			 db 81 dup(0)
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    lea dx,inputstring
    mov ah,09h
    int 21h;提示输入字符串
    
    mov dx,offset stringbuffer
    mov ah,0ah
    int 21h
    
    sub cx,cx
    mov cl,[stringbuffer+1]
    lea si,stringbuffer+2
    
digit:
	mov al,[si]
	cmp al,'0'
	jb other;小于0为其它字符
	cmp al,'9'
	ja captialletter;大于0仍需判断是否为大写字母
	inc digitnum;判断为数字 数量加1
	jmp again
	
captialletter:;大写字母判断
	cmp al,'A'
	jb other
	cmp al,'Z'
	ja smallletter;再判断是否为小写字母
	inc letternum;
	jmp again
smallletter:;小写字母判断
	cmp al,'a'
    jb other
    cmp al,'z'
    ja other
    inc letternum;
    jmp again
other:
	inc othernum
again:
	inc si
	dec cl
	cmp cl,0
	jz output;计数变量已经为0，跳转输出
	jne digit;继续下一个字符的判断
output:
	;输出letter个数
	lea dx,outputofletter
	mov ah,09h
	int 21h
	xor ax,ax
	mov al,letternum
	call convert
	
	;输出digit个数
	lea dx,outputofdigit
	mov ah,09h
	int 21h
	xor ax,ax
	mov al,digitnum
	call convert
	
	;输出other个数
	lea dx,outputofother
	mov ah,09h
	int 21h
	xor ax,ax
	mov al,othernum
	call convert
	

	
    MOV AH,4CH
    INT 21H
    
    convert proc near
	mov bl,10
	div bl;地位商高位余数
	push ax;因为后续需要使用ah所以入栈保存
	mov dl,al
	add dl,30h
	mov ah,02h
	int 21h;字符不会超过两位数
	
	pop ax
	mov dl,ah
	add dl,30h
	mov ah,02h
	int 21h
	
	ret
convert endp
CODES ENDS
    END START



