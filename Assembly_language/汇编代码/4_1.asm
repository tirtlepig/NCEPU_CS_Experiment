DATAS SEGMENT
    ;�˴��������ݶδ���  
    remind1 db 'Match!',0dh,0ah,'$'
    remind2 db 'NO Match',0dh,0ah,'$'
    remind3 db 'Please input one sentence:','$'
    remind4 db 'Please input your key word:','$'
    remind5 db 'The location is:','$'
    remind6 db 'H of this sentence',0dh,0ah,'$'
    remind7 db 'The deleted sentence is:',0dh,0ah,'$'
    key db 100,?,100 DUP(0)
   	sentence db 100,?,100 DUP(0);���Ⱦ�������100
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov es,ax;���ݶθ��Ӷ�ͬ��һ���߼���
    
    huanhang macro
	mov ah,02h
	mov dl,0dh
	INT 21H                              ; ����
	mov ah,02h
	mov dl,0ah
	INT 21H
	ENDM
	
	output      macro  string
	mov AH,09h                             ; ��ӡ�ַ���
	mov DX,OFFSET  string
	INT 21H
	ENDM
	
	input       macro  instring
	mov AH,10
	mov DX,OFFSET  instring                  ;�����ַ���
	INT 21H
	ENDM
    
    ;�˴��������δ���
	
    
again1:
    output remind3
    input sentence
    huanhang
    
    output remind4
    input key
    huanhang
    
	mov cl,[key+1]
	lea si,[key+2]        ;siΪkey��ͷָ��
	lea di,[sentence+2]        ;diΪsentence��ͷָ��
	mov bl,[sentence+1]
	sub bl,cl
	inc bl                   ;bl��ǰ����ַ���ʼ�Ƚϲ����ʱ�Ƚϵ�ѭ��������bl = sentence �C key + 1
again2:
	mov cl,[key+1]       ;cxΪkeyword�ĳ���
	and cx,0ffh          ;��λ����
	push si                  ;si��ջ
	push di                  ;di��ջ
	cld                      ;��λ�����־
	repz cmpsb
	jz match                 ;ѭ���Ƚ��ַ�������ͬ��ת����match
	pop di                   ;di��ջ
	pop si                   ;si��ջ
	inc di                   ;di+1
	dec bl                    ;bl-1
	jnz again2
	output remind2              ;���no match
	jmp again1
match:
	output remind1
	output remind5
	pop di
	pop si
	mov ax,di
	sub ax,offset[sentence+2]
	push ax
	mov cl,4                   	;���Ⱦ��޶�Ϊ100������ֻ�������λ����
	rol al,cl                   ;�����һλ
	and al,0fh					;ֻ��������λ
	add al,30h
	cmp al,39h					
	jbe next1					
	add al,07h					;����0-9 �ټ�07h

next1:
	mov dl,al                 ;�����һλ
	mov ah,02h
	int 21h
	pop ax
	and al,0fh                 ;����ڶ�λ
	add al,30h
	cmp al,39h
	jbe next2
	add al,07h
next2:
	mov dl,al                  ;����ڶ�λ
	mov ah,02h
	int 21h
	output remind6
	mov ax,di
	mov bl,[key+1]
	mov bh,0h
	add bx,di
	push bx;����di�µĿ�ʼλ��
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




