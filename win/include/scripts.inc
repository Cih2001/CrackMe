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
    lea ebx,	[Buffer.Input + %1]
    lea edx,    [Encrypted.String.Email.Domain]
    mov ecx,    %2
    %%loop_start:
    ; Read next char of password domain
    mov al, byte [ebx]
    ror al, 4
    ; Compare it with the encrypted text of domain @eset.com
    cmp al, byte [edx]
    jnz %%exit
    ; They match, Read next char
    inc edx
    inc ebx
    loop    %%loop_start
    ret
    %%exit:
        push    0
	    call    _ExitProcess@4
%endmacro

%macro  REPLACE_BYTES 0
    %line 1+1 test2.inc
%endmacro

%endif