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

%macro rc4table 0
    %assign i 0
    %rep 256
        db  i
        %assign i i+1
    %endrep
%endmacro

%endif