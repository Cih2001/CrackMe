DIR_ROOT	:=	..

include $(DIR_ROOT)/config/config.mk


all:
	$(NASM) -f obj -o $(DIR_BUILD)\$(DOS).obj $(DOS).asm
	$(ALINK) -oEXE $(DIR_BUILD)\$(DOS).obj
	$(PYTHON) $(DIR_CONFIG)\$(FIXER)