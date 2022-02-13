DATAS SEGMENT
    namepar   label    byte
	maxnlen   db     21
	actnlen   db     ?;ʵ���������
	_name     db     21 dup(?)  

	phonepar  label    byte
	maxplen   db     9
	actplen   db     ?
	_phone    db     9 dup(?)

	crlf      db     0dh,0ah,'$';����

	endaddr   dw     ?

	string1   db     'Input name:','$'
	string2   db     'Input a telephone number:','$'
	string3   db     'Do you want a telephone number?(Y/N)','$'
	string4   db     'name?','$'
	string5   db     'name',16 dup(' '),'tel',0dh,0ah,'$'
	string6   db     'Finish search.',0dh,0ah,'$'
	string7   db     'Invalid input!',0dh,0ah,'$'
	
	count     db     0
	tel_tab   db     50 dup(20 dup(' '),8 dup(' '));���ɴ��50��绰������
	temp      db     20 dup(' '),8 dup(' '),0dh,0ah,'$';��ʱ����
	swapped   db     0

DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:DATAS
START:
      MOV AX,DATAS
      MOV DS,AX
      mov     es,ax
      lea     di,tel_tab      ;di�д�ű��׵�ַ
      
inputloop:
      
      lea     dx,string1
      mov     ah,09h
      int     21h          ;'Input name'
      
      call    input_name
      cmp     actnlen,0    ;û����������ʱ
      jz      advice            ;ֱ��������ʾ�Ƿ���ҵĵط�
      cmp     count,50     ;��������
      je      advice  
      call    store_name    ;����������tel_tab
                      
      mov     ah,09h       ;'Input a telephone number'
      lea     dx,string2
      int     21h      
      call    input_store_phone ;���벢����绰����
      jmp     inputloop

advice:
      cmp     count,1
      jbe     sloop ;���û�������������һ�� 
      call    disp_all  ;��ʾ����

sloop:
      lea     dx,string3
      mov     ah,09h
      int     21h 
      
      mov     ah,01h
      int     21h      
      ;��Сд����Ҫ�ж�
      cmp     al,'N'
      je      exit
      cmp     al,'n'
      je      exit
      cmp     al,'Y'
      je      sname
      cmp     al,'y'
      je      sname
      
      mov     ah,09
      lea     dx,crlf
      int     21h 
      lea     dx,string7 ;�Ƿ�����
      mov     ah,09h
      int     21h      
      
      jmp     sloop
      
sname:      
      mov     ah,09
      lea     dx,crlf
      int     21h      
        
      lea     dx,string4 ;������Yʱ,��ʾ'name?'
      mov     ah,09
      int     21h 
      
      call    input_name ;����Ҫ���ҵ�����
      mov     ah,09h
      lea     dx,string5
      int     21h
      call    name_search ;����
	  call    sprint
      jmp     sloop     
exit:
      MOV AH,4CH
      INT 21H 


input_name    proc    near      ;��������
      mov     ah,0ah
      lea     dx,namepar
      int     21h
      mov     ah,02h
      mov     dl,0ah ;����
      int     21h
      
      mov     bh,0
      mov     bl,actnlen
      mov     cx,21
      sub     cx,bx
n:	;���㳤����ѭ�� 
      mov     _name[bx],20h
      inc     bx
      loop    n
      ret
input_name endp            


store_name  proc    near		;������
      inc     count
      cld     
      lea     si,_name
      mov     cx,20        ;��name�е�ǰ20���ַ�����tel_tab��ÿһ������Ϣ��ǰ20��byte��
      rep     movsb
      ret
store_name  endp   

                  
input_store_phone  proc  near	;���մ���绰���뱾��
      
      mov     ah,0ah
      lea     dx,phonepar
      int     21h      
      mov     ah,02h
      mov     dl,0ah ;����
      int     21h
      
      mov     bh,0
      mov     bl,actplen
      mov     cx,9
      sub     cx,bx ;����ʣ�µĳ���

s:
      mov     _phone[bx],20h ;ʣ�µĵط����ո�
      inc     bx
      loop    s
         
      cld     
      lea     si,_phone
      mov     cx,8      ;��phone�е�ǰ8���ַ�����tel_tab��ÿһ������Ϣ�ĺ�8��byte��
      rep     movsb    
      ret
input_store_phone endp         

disp_all  proc    near
      mov     ah,09h
      lea     dx,string5
      int     21h
      lea     si,tel_tab
n1:
      lea     di,temp
      mov     cx,14
      rep     movsw
      mov     ah,09h
      lea     dx,temp
      int     21h
      dec     count
      jnz     n1
      ret     
      
disp_all  endp     


name_search proc    near            
      lea     si,tel_tab
      mov     bx,si
      add     endaddr,28
n1:           
      lea     di,_name     ;��Ŵ����ҵ�������ַ
      mov     cx,10
      repe    cmpsw
      jcxz    nase_exit    ;���
n2:      
      add     bx,28        ;������һ���Ƚϵ�����
      mov     si,bx
      cmp     si,endaddr
      jbe     n1
      ja      notintab
notintab: 
      mov     cx,-1
      ret
nase_exit: 
      mov     si,bx
      lea     di,temp
      mov     cx,14
      rep     movsw
      call    sprint
      jmp     n2
      ret                  
name_search endp  


sprint  proc    near
      cmp     cx,-1
      je      n
      
      mov     ah,09h
      lea     dx,temp     
      int     21h
      ret
n:
      mov     ah,09h
      lea     dx,string6
      int     21h           
      ret
sprint  endp         
CODES ENDS
    END START










