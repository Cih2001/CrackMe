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

%include "include\scripts.inc"	; Contains general purpose scripts
%include "include\dos.inc"		; Contains the implementation of DOS functions

SECTION         .text
	
	extern  _GetStdHandle@4
	extern  _WriteFile@20
	extern  _ExitProcess@4

	global _main				; PE Entry

;==========================================================================
; Here is the place that DOS application will be continued.
;==========================================================================
bits 16
_main16:
	;Setting up segment registers.
	;mov     ax,	dataseg 
	;mov     ds,	ax

	; Checking that time is between 12am and 1am
	call	CheckTime16
	jnc		.time_in_bound
	mov ax, 0x4c01
    int 0x21        ; Terminates application.

	.time_in_bound:

	jmp	$
;==========================================================================
; Entry of 32 bit PE application.
;==========================================================================
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

;==========================================================================
; CheckTime16
;
; Checks to see if the time of execution of program is between defind boundries or not
; Current boundry is between 12 am and 1 am
;
; @return	CF is set if time is out of bound
;==========================================================================
bits 16
CheckTime16:
	DEFINE_CHECK_TIME	0,	24
	
SECTION		.data

; RC4TABLE - it is used in both in win32 and dos apps
RC4TableSignature:	db	0xde,0xad,0xbe,0xef
RC4Table:				rc4table

Message:	db      'Hello World!', 10
MsgLen:		equ     $-Message