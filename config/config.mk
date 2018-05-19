
#--------------------
# Project directories
#--------------------
DIR_DOS	:= $(DIR_ROOT)\dos
DIR_BUILD	:= $(DIR_ROOT)\build
DIR_WIN	:= $(DIR_ROOT)\win
DIR_CONFIG 	:= $(DIR_ROOT)\config

#-------------------
# Project files
#-------------------

DOS			:=	DosStub
PE			:=	CrackMe

#-------------------
# Tool configuration
#-------------------

NASM		:= nasm

ALINK		:= alink

LINK		:= link

MAKE_FLAGS	:= --quiet --no-print-directory

BOCHS		:= bochs


#---------------------
# Display color macros
#---------------------
BLUE		:= \033[1;34m
YELLOW		:= \033[1;33m
NORMAL		:= \033[0m

SUCCESS		:= $(YELLOW)SUCCESS$(NORMAL)