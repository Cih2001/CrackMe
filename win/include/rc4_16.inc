;=============================================================================
; @file rc6_16.inc
;
; It is the implementation of RC4 algorithm in 16 bit DOS mode.
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_RC4_16_INC__
%define __CRACKME_RC4_16_INC__

%define i       bp-2
%define j       bp-4
%define arg0    bp+4
%define arg1    bp+6

%macro table_read 2
    mov bx,	$$ + RC4Table
    add bx, [%2]
    mov %1, byte [bx] 
%endmacro

%macro  table_save 2
    mov bx,	$$ + RC4Table
    add bx, [%1]
    mov byte [bx], %2 
%endmacro

%macro  key_read 2
    ; mov al, key [i mod len]
    mov ax, [%2]
    mov dx, 0     
	mov bx, [key_len]
	div bx       ; Divides dx:ax by bx. DX = remainder and AX = qotient

    mov bx, [key]
    add bx, dx
    mov %1, byte[bx]
%endmacro

%macro  mod 2
    mov ax, %1
    mov dx, 0     
	mov bx, %2
	div bx       ; Divides dx:ax by bx. DX = remainder and AX = qotient
    mov %1, dx
%endmacro

%macro  RC4_16 0
    KSA16:
        KAS_16
    PRGA16:
        PRGA_16
%endmacro

%macro  KAS_16 0
    %define key arg0
    %define key_len arg1

    push bp
    mov bp, sp
    push 0  ; i = 0
    push 0  ; j = 0
     
    %%.loop_start:
        ; compute j = j + S[i] + key[i mod key_len]
        mov cx, [j] 

        ; + s[i]
        table_read  al, i
        xor ah, ah
        add cx, ax

        ; + key[i mod key_len]
        key_read    al, i
        xor ah, ah
        add cx, ax

        mod cx, 0x100
        ; save j
        mov [j], cx

        ; swap S[i], S[j]
        table_read  al, i  ; al = S[i]
        table_read  ah, j  ; ah = S[j]
        table_save  i, ah
        table_save  j, al
        ; i++
        inc word [i]
    cmp word [i], 0x100           ;   loop 255
    jb %%.loop_start
    
    mov sp, bp
    pop bp
    ret 4
%endmacro

%macro  PRGA_16 0
    %define input_16 arg0
    %define input_16_len arg1
    push bp
    mov bp, sp
    push 0  ; i = 0
    push 0  ; j = 0

    %%.loop:
        cmp word [input_16_len], 0
        jz %%.exit
        ; i++
        inc word [i]

        ; compute j = (j + S[i]) mod 256
        mov cx, [j] 

        ; + S[i]
        table_read  al, i
        xor ah, ah
        add cx, ax
        mod cx, 0x100

        ; update j
        mov [j], cx

        ; swap S[i], S[j]
        table_read  al, i  ; al = S[i]
        table_read  ah, j  ; ah = S[j]
        table_save  i, ah
        table_save  j, al

        ; G = S[(S[i]+S[j]) mod 256]
        table_read  cl, i
        table_read  al, j
        add cl, al
        xor ch, ch
        add cx, $$ + RC4Table
        xchg    cx, bx
        mov al, byte [bx]

        ; update input[i] ^= G
        mov bx, [input_16]
        add bx, [i]
        xor byte [bx-1] , al
    
        dec word [input_16_len]
    jmp %%.loop

    %%.exit:
    mov sp, bp
    pop bp
    ret 4
%endmacro

%endif