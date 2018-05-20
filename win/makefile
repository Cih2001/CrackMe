DIR_ROOT	:=	..

include $(DIR_ROOT)/config/config.mk

all:
	$(NASM) -fwin32 -o $(DIR_BUILD)\$(PE).obj $(PE).asm
	$(LINK) /subsystem:console,5.1 /nodefaultlib /entry:main /stub:$(DIR_BUILD)\$(DOS).exe /version:5.1 /out:$(DIR_BUILD)\$(PE).exe $(DIR_BUILD)\$(PE).obj kernel32.lib
	$(PYTHON) $(DIR_CONFIG)\$(PYSCRIPT) rot_string $(DIR_BUILD)\$(PE).exe "@eset.com"