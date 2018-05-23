;=============================================================================
; @file scripts.inc
;
; It contains nasm macros that are used in the application.
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_SCRIPTS_INC__
%define __CRACKME_SCRIPTS_INC__

%macro  rc4table    0
    %assign i 0
    %rep 256
        db  i
        %assign i i+1
    %endrep
%endmacro


%macro  ENC_SECOND_CODE 2
    nop
    call    $ + 5
    pop eax
    and eax, 0xffff0000
    lea ebx, [Buffer.Input - $$ + 0x1000 + %1]
    lea edx, [Encrypted.String.Email.Domain - $$ + 0x1000]
    add ebx, eax
    add edx, eax
    mov ecx,    %2
    %%loop_start:
    ; Read next char of password domain
    mov al, byte [ebx]
    ror al, 4
    ; Compare it with the encrypted text of domain @eset.com
    cmp al, byte [edx]
    jnz %%error
    ; They match, Read next char
    inc edx
    inc ebx
    loop    %%loop_start
    mov eax, 1
    ret
    %%error:
    mov eax, 0
    ret
%endmacro

%endif