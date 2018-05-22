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
    push edx
    mov eax, %2
    mov edx, 0     
	mov ebx, [key_len]
	div ebx       ; Divides dx:ax by bx. DX = remainder and AX = qotient
    and edx, 0x000000ff
    mov ebx, [key]
    add ebx, edx
    movzx %1, byte[ebx]
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
    push    0 ; for i
    push    0 ; for j

    leave
    ret 8
%endmacro

%endif