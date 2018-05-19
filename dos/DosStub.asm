segment code 

..start:
	jmp		$
	push	ax
	push	bx
	mov     ax,data 
	mov     ds,ax 
	mov     ax,stack 
	mov     ss,ax 
	mov     sp,stacktop
	mov     dx,hello 
	mov     ah,9 
	int     0x21
	mov     ax,0x4c00 
	int     0x21

segment data 

hello:  db      'This program cannot be run in DOS mode after 1am.', 13, 10, '$'

segment stack stack 
	resb 64 
stacktop: