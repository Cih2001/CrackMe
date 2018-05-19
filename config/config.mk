
#--------------------
# Project directories
#--------------------
DIR_DOS	:= $(DIR_ROOT)\dos
DIR_BUILD	:= $(DIR_ROOT)\build
DIR_WIN	:= $(DIR_ROOT)\win
DIR_CONFIG 	:= $(DIR_ROOT)\config
DIR_DEBUG	:= $(DIR_ROOT)\debug
#-------------------
# Project files
#-------------------

DOS			:=	DosStub
PE			:=	CrackMe
FLOPPY		:=	floppy.img
DISK		:=	disk.img

#-------------------
# Tool configuration
#-------------------

NASM		:= nasm

ALINK		:= alink

LINK		:= link

MAKE_FLAGS	:= --quiet --no-print-directory

BOCHS		:= bochs

BFI			:= bfi
#---------------------
# Display color macros
#---------------------
BLUE		:= \033[1;34m
YELLOW		:= \033[1;33m
NORMAL		:= \033[0m

SUCCESS		:= $(YELLOW)SUCCESS$(NORMAL)