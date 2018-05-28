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
%include "include\dos.inc"	; Contains the implementation of DOS functions
%include "include\constants.inc"; Contains project constants
%include "include\rc4_16.inc"	; Contains RC4 implementation in DOS mode.
%include "include\rc4_32.inc"	; Contains RC4 implementation for Win32.
%include "include\obfuscation_16.inc"	; Contains obfuscation methods for DOS mode.
%include "include\obfuscation_32.inc"	; Contains obfuscation methods for Win32.

SECTION	.text
	
	extern	_GetStdHandle@4
	extern	_WriteFile@20
	extern	_ExitProcess@4
	extern	_ReadFile@20
	extern	_GetLastError@0

	global	_main	; PE Entry

;==========================================================================
; Here is the place that DOS application will be continued.
;==========================================================================
bits 16
_main16:
	;Setting up segment registers.
	OBFUSCATION_OPAQE_PRED_2 c, 0xe8, 0x90
	OBFUSCATION_SHARED_BYTE

	mov	ax, cs
	mov	ds, ax

	call	CheckTime16
	jnc	.time_in_bound
	mov	ax, 0x4c01
	int	0x21; Terminates application.

	.time_in_bound:

	; Writing 'Enter password' message.
	mov	dx, $$ + String.EnterPassword 
	mov	ah, 9
	OBFUSCATION_OPAQE_PRED_2 z, 0xeb
	int	0x21

	mov	dx, $$ + Buffer.Input	; Input buffer offset
	mov	cx, BUFFER_INPUT_LENGTH	; No of chars to read
	xor	bx, bx	; Std in
	mov	ah, 0x3f	; DOS read
	OBFUSCATION_OPAQE_PRED_2 s, 0xff, 0x90, 0xeb
	int	21h
	jc .error

	; Store the password length for future use
	sub	ax, 2	; removing cr lf.
	mov	bx, $$ + Variables
	mov	word [ds:bx + GlobalVars.Input.Length], ax
	
	; End if password is not 4 char.
	; Password is chosen to be 4 char in length to let bruteforce be
	; possible at a convenient amount of time.
	cmp	ax, 3
	jb	.error
	OBFUSCATION_OPAQE_PRED_2 b, 0xe8
	push	3	; Key length
	push	$$ + Buffer.Input  ; Key
	call	KSA16

	OBFUSCATION_OPAQE_PRED_2 c, 0xe8, 0x90
	OBFUSCATION_SHARED_BYTE
	push	ENC.End - ENC.Signature0	; data length
	push	$$ + ENC.Signature0	; data to decrypt
	call	PRGA16

	;Checking for the signature.
	mov	bx, $$ + ENC.Signature0
	cmp	byte [bx], 0xde
	OBFUSCATION_OPAQE_PRED_2 z, 0xf6
	jnz	.error
	cmp	byte [bx + 1], 0xad
	OBFUSCATION_OPAQE_PRED_2 z, 0xeb, 0xbe, 0x0
	jnz	.error
	cmp	byte [bx + 2], 0xbe
	OBFUSCATION_OPAQE_PRED_2 z, 0xe3
	jnz	.error
	cmp	byte [bx + 3], 0xef
	OBFUSCATION_OPAQE_PRED_2 z, 0xac
	jnz	.error
	mov	bx, $$ + ENC.First.CodeStart
	jmp	bx
	.error:
	; Writing wrong message.
	mov	dx, $$ + String.Wrong 
	mov	ah, 9
	OBFUSCATION_SHARED_BYTE
	int	0x21
	; Terminates application.
	mov	ax, 0x4c01
	int	0x21

;==========================================================================
; CheckTime16
;
; Checks to see if the time of execution of program is between defind boundries or not
; Current boundry is between 12 am and 1 am
;
; @return	CF is set if time is out of bound
;==========================================================================
CheckTime16:
	DEFINE_CHECK_TIME	DOS_TIME_LOW_BOUND, DOS_TIME_HIGH_BOUND

;==========================================================================
; RC4 implementation in DOS.
;==========================================================================
RC4_16

; It's a signature for python script to find end of DOS region.
DOS.End:	db	0xbe, 0xef

;==========================================================================
; Entry of 32 bit PE application.
;==========================================================================
bits 32
_main:
	; DWORD  bytes; 
	pusha   
	mov	ebp, esp
	sub	esp, 4

	push	String.EnterPassword.Length
	push	String.EnterPassword
	call	WriteMessage32

	push	STD_INPUT_HANDLE
	call	_GetStdHandle@4
	mov	ebx, eax

	push	0	; lpOverlapped
	lea	eax, [ebp-4]
	push	eax	; lpNumberOfBytesRead
	push	BUFFER_INPUT_LENGTH ; nNumberOfBytesToRead
	push	Buffer.Input	; lpBuffer
	push	ebx	; hFile
	call	_ReadFile@20
	test	eax, eax
	jz	.error
	
	; RC4 input with first phase (email)
	; cmp sig1
	; jnz .wrong
	push	PASSWORD_DOMAIN_START
	push	Buffer.Input
	call	KSA32

	push	ENC.Signature2 - ENC.Signature0
	push	ENC.Signature0
	call	PRGA32

	cmp	byte [ENC.Signature1], 0xba
	jnz	.wrong
	cmp	byte [ENC.Signature1+1], 0xdb
	jnz	.wrong
	cmp	byte [ENC.Signature1+2], 0x00
	jnz	.wrong
	cmp	byte [ENC.Signature1+3], 0xb5
	jnz	.wrong

	call	ENC.Second.CodeStart
	test	eax, eax
	jz	.wrong

	mov	eax, [ebp-4] ; Number of read bytes.
	sub	eax, 2	 ; Remove CR LF from end of string
	push	eax
	push	Buffer.Input
	call	KSA32

	push	ENC.End - ENC.Signature0
	push	ENC.Signature0
	call	PRGA32
	; RC4 input with whole password (email@domain)
	cmp	byte [ENC.Signature2], 0xbe
	jnz	.wrong
	cmp	byte [ENC.Signature2+1], 0x57
	jnz	.wrong
	cmp	byte [ENC.Signature2+2], 0xc0
	jnz	.wrong
	cmp	byte [ENC.Signature2+3], 0xde
	jnz	.wrong

	push	String.Correct.Length
	push	String.Correct
	call	WriteMessage32
	jmp	.exit
	
	.error:
		call	_GetLastError@0
		jmp	.exit
	.wrong:
		push	String.Wrong.Length
		push	String.Wrong
		call	WriteMessage32
	.exit:
		mov	esp, ebp
		popa
		push	0
		call	_ExitProcess@4

	; never here
	hlt
	leave
	ret
;==========================================================================
; RC4 implementation for Win32.
;==========================================================================
RC4_32

;==========================================================================
; WriteMessage32
;
; Writes a message on std output in 32 bit mode.
;
; @return	CF is set if time is out of bound
;==========================================================================
WriteMessage32:
	Arg.Message.Len	equ 0xC
	Arg.Message	equ 0x8
	push	ebp
	mov	ebp, esp
	sub	esp, 4

	push	STD_OUTPUT_HANDLE
	call	_GetStdHandle@4
	mov	ebx, eax    

	; WriteFile( hstdOut, message, length(message), &bytes, 0);
	push	0	; lpOverlapped
	lea	eax, [ebp-4]
	push	eax	; Number of bytes written
	mov	eax, [ebp + Arg.Message.Len]
	push	eax	; Number of bytes to write
	mov	eax, [ebp + Arg.Message]
	push	eax	; buffer
	push	ebx	; file handle
	call	_WriteFile@20

	leave
	ret	8
;==========================================================================
; ENCRYPTED INSTRUCTIONS AND DATA
; THESE INSTRUCTIONS AND DATA SHOULD BE ENCRYPTED USING PYTHON SCRIPT 
; AFTER LINKING IN BINARY FILE

ENC.Signature0:	db	0xde,0xad,0xbe,0xef
bits 16
ENC.First.CodeStart:
	; Writing 'Good job' message.
	mov	dx, $$ + ENC.First.Data 
	mov	ah, 9 
	int	0x21
	; Terminate the program
	mov	ax, 0x4c01
	int	0x21
ENC.First.Data:	db	'Good job! for all your efforts, I give you a hint.', 0xd, 0xa, 'Password begins with: github.com', '$', 0
; ABOVE CODE SHOULD BE ENCRYPTED BY CrAc

ENC.Signature1:	db	0xba,0xdb,0x00,0xb5
ENC.First.Data.Length:	equ	$-ENC.First.Data-2
bits 32
ENC.Second.CodeStart:
	ENC_SECOND_CODE	PASSWORD_DOMAIN_START, PASSWORD_DOMAIN_LENGTH
;ABOVE CODE SHOULD BE ENCRYPTED BY CrAcKMe2018

ENC.Signature2:	db	0xbe,0x57,0xc0,0xde
ENC.End:
;ABOVE CODE SHOULD BE ENCRYPTED BY CrAcKMe2018@eset.com
;==========================================================================

Buffer.Input:	times	BUFFER_INPUT_LENGTH	db	0
Variables:
	istruc	GlobalVars
		at	GlobalVars.Input.Length,	dw	0	; Length of enterd password
	iend
; rc4table is used in both in win32 and dos apps
LookupTable:						rc4table
String.EnterPassword:			db	'Enter Password:', '$', 0
String.EnterPassword.Length:	equ	$-String.EnterPassword-2
String.Wrong:					db	'Hmm, Not exactly! Try harder.', 0xD, 0xA, '$', 0
String.Wrong.Length:			equ	$-String.Wrong-2
String.Correct:					db	'Congratulations, You are a winner!', 0xD, 0xA, '$', 0
String.Correct.Length:			equ	$-String.Correct-2


Str.Test:	db 'This is a test string with no use',0
Str.Test.Length:	equ	$-Str.Test-1

SECTION	.data
;==========================================================================
; ENCRYPTED INSTRUCTIONS AND DATA
; THESE INSTRUCTIONS AND DATA SHOULD BE ENCRYPTED USING PYTHON SCRIPT 
; AFTER LINKING IN BINARY FILE

Encrypted.String.Addr.Domain:			db '/cih2001/CrackMe', 0
Encrypted.String.Addr.Domain.Length:	equ	$ - Encrypted.String.Addr.Domain-1
;==========================================================================
