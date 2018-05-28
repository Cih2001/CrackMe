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

; PASSWORD: github.com/cih2001/CrackMe

PASSWORD_LENGTH equ 26
PASSWORD_DOMAIN_START   equ 10
PASSWORD_DOMAIN_LENGTH  equ PASSWORD_LENGTH - PASSWORD_DOMAIN_START

DOS_TIME_LOW_BOUND  equ 0
DOS_TIME_HIGH_BOUND equ 1

BUFFER_INPUT_LENGTH equ 0x20

STD_INPUT_HANDLE    equ -10
STD_OUTPUT_HANDLE   equ -11
; It's an structure that contains all global variables.
struc GlobalVars
    .Input.Length   resw    1   ; Length of entered password
endstruc

%endif