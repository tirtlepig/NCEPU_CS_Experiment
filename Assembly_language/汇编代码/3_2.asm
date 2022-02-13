DATAS SEGMENT
    ;�˴��������ݶδ��� 
    letternum db 0;��ĸ����
    digitnum db 0;���ָ���
    othernum db 0;�����ַ�����
    
    inputstring db 'Please input one string:','$';��������
    ;�����������ʾ
    outputofletter db 0dh,0ah,'The number of letter is:','$';��ĸ����
    outputofdigit db 0dh,0ah,'The number of digit is:','$';���ָ���
    outputofother db 0dh,0ah,'The number of other is:','$';�����ַ�����
    
    stringbuffer db 80;�ַ���������
    			 db 0
    			 db 81 dup(0)
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    lea dx,inputstring
    mov ah,09h
    int 21h;��ʾ�����ַ���
    
    mov dx,offset stringbuffer
    mov ah,0ah
    int 21h
    
    sub cx,cx
    mov cl,[stringbuffer+1]
    lea si,stringbuffer+2
    
digit:
	mov al,[si]
	cmp al,'0'
	jb other;С��0Ϊ�����ַ�
	cmp al,'9'
	ja captialletter;����0�����ж��Ƿ�Ϊ��д��ĸ
	inc digitnum;�ж�Ϊ���� ������1
	jmp again
	
captialletter:;��д��ĸ�ж�
	cmp al,'A'
	jb other
	cmp al,'Z'
	ja smallletter;���ж��Ƿ�ΪСд��ĸ
	inc letternum;
	jmp again
smallletter:;Сд��ĸ�ж�
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
	jz output;���������Ѿ�Ϊ0����ת���
	jne digit;������һ���ַ����ж�
output:
	;���letter����
	lea dx,outputofletter
	mov ah,09h
	int 21h
	xor ax,ax
	mov al,letternum
	call convert
	
	;���digit����
	lea dx,outputofdigit
	mov ah,09h
	int 21h
	xor ax,ax
	mov al,digitnum
	call convert
	
	;���other����
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
	div bl;��λ�̸�λ����
	push ax;��Ϊ������Ҫʹ��ah������ջ����
	mov dl,al
	add dl,30h
	mov ah,02h
	int 21h;�ַ����ᳬ����λ��
	
	pop ax
	mov dl,ah
	add dl,30h
	mov ah,02h
	int 21h
	
	ret
convert endp
CODES ENDS
    END START



