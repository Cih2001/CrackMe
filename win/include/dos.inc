;=============================================================================
; @file dos.inc
;
; It 16 bit code and functions that are embeded in pe when application is run in DOS. 
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_DOS_INC__
%define __CRACKME_DOS_INC__

;=============================================================================
; Implementation of CheckTime16 function.
;
; @param    low bound
; @param    high bound
;=============================================================================
%macro  DEFINE_CHECK_TIME   2
	mov ax, 0x2c00  ; Get system time 
    int 0x21        ; DOS api
    
    ; Check lower bound
    cmp ch, %1
    jb  %%out_of_bound

    ; Check upper bound
    cmp ch, %2
    jae  %%out_of_bound

    ; In bound. Clear carry flag and return
    clc
    jmp %%end

    %%out_of_bound:
    stc
    %%end:
	ret
%endmacro

%endif