;=============================================================================
; @file constants.inc
;
; It contains constant values that are needed in the project.
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%ifndef __CRACKME_CONSTANTS_INC__
%define __CRACKME_CONSTANTS_INC__

BUFFER_INPUT_LENGTH equ 0x10

; It's an structure that contains all global variables.
struc GlobalVars
    .Input.Length   resw    1   ; Length of entered password
endstruc

%endif