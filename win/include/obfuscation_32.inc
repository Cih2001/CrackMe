;=============================================================================
; @file obfuscation_32.inc
;
; Some obfuscation methods for 32 bit application. 
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_OBFUSCATION_32_INC__
%define __CRACKME_OBFUSCATION_32_INC__

%macro  OBFUSCATION_SHARED_BYTE 0
    db 0x74, 0x03 ,0x75 ,0x01 ,0xEB ,0x05 ,0x00 ,0x00 ,0x00 ,0x00 ,0xEB ,0xF8
%endmacro

%macro OBFUSCATION_OPAQE_PRED_2 2+
    j%1 %%.real
    jn%1  %%.real
    %rotate 1
    %rep  %0 - 1 
        db    %1 
        %rotate 1 
    %endrep
    %%.real:
%endmacro

%endif
