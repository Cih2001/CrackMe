;=============================================================================
; @file rc6_32.inc
;
; It is the implementation of RC4 algorithm for Win32.
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_RC4_32_INC__
%define __CRACKME_RC4_32_INC__

%define i       ecx
%define j       edx
%define arg0    ebp + 0x8
%define arg1    ebp + 0xC

%macro  key_read32 2
    ; mov al, key16 [i mod len]
    push    edx
    mov eax, %2
    mov edx, 0     
    mov ebx, [key_len]
    div ebx       ; Divides dx:ax by bx. DX = remainder and AX = qotient
    and edx, 0x000000ff
    mov ebx, [key]
    add ebx, edx
    movzx   %1, byte[ebx]
    pop edx
%endmacro

%macro  RC4_32 0
    KSA32:
        KSA_32
    PRGA32:
        PRGA_32
%endmacro

%macro  KSA_32 0
    %define key arg0
    %define key_len arg1
    push    ebp
    mov ebp, esp
    ; init lookup table
    mov ecx, 0xFF
    mov byte [LookupTable] , 0
    %%.lookup_set:
        mov byte [ecx + LookupTable] , cl
    loop %%.lookup_set

    mov i, 0
    mov j, 0
    %%.loop_start:
        ; compute j = j + S[i] + key16[i mod key16_len]
        ; + s[i]
        movzx   eax, byte [i + LookupTable]
        add j, eax

        ; + key16[i mod key_len]
        key_read32  eax, i
        add j, eax
        and j, 0x000000ff

        ; swap S[i], S[j]
        movzx   eax, byte [i + LookupTable]
        movzx   ebx, byte [j + LookupTable]
        mov byte [i + LookupTable], bl
        mov byte [j + LookupTable], al

        inc i
        cmp i, 0x100           ;   loop 255
    jb %%.loop_start

    leave
    ret 8
%endmacro

%macro  PRGA_32 0
    %define input arg0
    %define input_len arg1
    push    ebp
    mov ebp, esp
    
    mov i, 0
    mov j, 0

    %%.loop:
        cmp dword [input_len], 0
        jz %%.exit
        ; i++
        inc i

        ; compute j = (j + S[i]) mod 256
        ; + S[i]
        movzx   eax, byte [i + LookupTable]
        add j, eax
        and j, 0x000000ff

        ; swap S[i], S[j]
        movzx   eax, byte [i + LookupTable]
        movzx   ebx, byte [j + LookupTable]
        mov byte [i + LookupTable], bl
        mov byte [j + LookupTable], al

        ; G = S[(S[i]+S[j]) mod 256]
        movzx   eax, byte [i + LookupTable]
        movzx   ebx, byte [j + LookupTable]
        add eax, ebx
        and eax, 0x000000ff
        movzx   eax, byte [eax + LookupTable]

        ; update input[i] ^= G
        mov ebx, [input]
        add ebx, i
        xor byte [ebx-1] , al
    
        dec dword [input_len]
    jmp %%.loop

    %%.exit:
    leave
    ret 8
%endmacro

%endif