DATAS SEGMENT
    ;�˴��������ݶδ���  
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
    mov cx,15
    mov dl,10h
    
loop1:
	push cx
	mov cx,16
loop2:
	mov ah,02h
	int 21h
	inc dl
	push dx;push/pop����ֲ��� �浱ǰ��cxֵ ������Ҫ����հ�
	mov ah,02h
	mov dl,00h;�հ�
	int 21h
	pop dx
	loop loop2;ִ����ѭ��
	push dx
	mov ah,02h
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h
	pop dx
	pop cx;�������ѭ��ֵ
	loop loop1;ִ����ѭ��
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
