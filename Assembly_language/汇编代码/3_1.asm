DATAS SEGMENT
    ;此处输入数据段代码  
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
    mov cx,15
    mov dl,10h
    
loop1:
	push cx
	mov cx,16
loop2:
	mov ah,02h
	int 21h
	inc dl
	push dx;push/pop针对字操作 存当前的cx值 后续需要输出空白
	mov ah,02h
	mov dl,00h;空白
	int 21h
	pop dx
	loop loop2;执行内循环
	push dx
	mov ah,02h
	mov dl,0dh
	int 21h
	mov ah,02h
	mov dl,0ah
	int 21h
	pop dx
	pop cx;返回外层循环值
	loop loop1;执行外循环
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
