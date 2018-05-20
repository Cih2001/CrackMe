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
%include "include\constants.inc"; Contains project constants

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
	mov ax,	cs
	mov	ds,	ax

	call	CheckTime16
	jnc	.time_in_bound
	mov	ax,	0x4c01
	int	0x21	; Terminates application.

	.time_in_bound:

	; Writing 'Enter password' message.
	mov	dx,	$$ + String.EnterPassword 
	mov	ah,	9 
	int	0x21

	mov	dx,	$$ + Buffer.Input	; Input buffer offset
	mov cx, BUFFER_INPUT_LENGTH	; No of chars to read
	mov al,	0					; Std in
	mov ah, 0x3f				; DOS read
    int 21h
	jc .error

	; Store the password length for future use
	mov bx, $$ + Variables
	mov word [ds:bx + GlobalVars.Input.Length], ax
	
	; End if password is not 4 char.
	; Password is chosen to be 4 char in length to let bruteforce be
	; possible at a convenient amount of time.
	cmp	ax,	4
	jnz	.error

	jmp	$

	.error:
	; Writing wrong message.
	mov	dx,	$$ + String.Wrong 
	mov	ah,	9 
	int	0x21
	; Terminates application.
	mov	ax,	0x4c01
	int	0x21	

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
	push    0							; lpOverlapped
	lea     eax, [ebp-4]
	push    eax							; Number of bytes written
	push    String.EnterPassword.Length	; Number of bytes to write
	push    String.EnterPassword		; buffer
	push    ebx							; file handle
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


;SECTION		.data
Buffer.Input:				times	BUFFER_INPUT_LENGTH	db	0
Variables:
	istruc	GlobalVars
		at	GlobalVars.Input.Length,	dw	0	; Length of enterd password
	iend
; rc4table is used in both in win32 and dos apps
RC4Table.Signature:			db	0xde,0xad,0xbe,0xef
RC4Table.Start:				rc4table
String.EnterPassword:		db	'Enter Password:', '$', 0
String.EnterPassword.Length:	equ	$-String.EnterPassword-2
String.Wrong:				db	'Hmm, Not exactly! Try harder', 0xD, 0xA, '$', 0
String.Wrong.Length:		equ	$-String.EnterPassword-2
String.Correct:				db	'Congratulations, You are a winner!', 0xD, 0xA, '$', 0
String.Correct.Length:		equ	$-String.Correct-2


