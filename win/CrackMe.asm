;=============================================================================
; @file CrackMe.asm
;
; It's the 32 bit main pe. However it contains the code that is going to be executed
; when the execution is passed from dos stub.
;
; Copyright 2017 Hamidreza Ebtehaj.
; Use of this source code is governed by a BSD-style license that can
; be found in the LICENSE file.
;=============================================================================

%include "include\scripts.inc"

SECTION         .text

	extern  _GetStdHandle@4
	extern  _WriteFile@20
	extern  _ExitProcess@4

	global _main

; Here is the place that DOS application will be continued.
bits 16
_main16:
	call CheckTime


bits 32
_main:
	; DWORD  bytes;    
	mov     ebp, esp
	sub     esp, 4

	; hStdOut = GetstdHandle( STD_OUTPUT_HANDLE)
	push    -11
	call    _GetStdHandle@4
	mov     ebx, eax    

	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push    0			; lpOverlapped
	lea     eax, [ebp-4]
	push    eax			; Number of bytes written
	push    MsgLen			; Number of bytes to write
	push    Message			; buffer
	push    ebx			; file handle
	call    _WriteFile@20

	; ExitProcess(0)
	push    0
	call    _ExitProcess@4

	; never here
	hlt

bits 16
CheckTime:
	jmp $
	ret
	
SECTION		.data
; RC4TABLE - it is used in both in win32 and dos apps
RC4TableSignature:	db	0xde,0xad,0xbe,0xef
rc4table

Message:	db      'Hello World!', 10
MsgLen:		equ     $-Message