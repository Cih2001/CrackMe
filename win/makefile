DIR_ROOT	:=	..

include $(DIR_ROOT)/config/config.mk

all:
	$(NASM) -fwin32 -o $(DIR_BUILD)\$(PE).obj $(PE).asm
	$(LINK) /subsystem:console,5.1 /nodefaultlib /entry:main /section:.text,RWE /stub:$(DIR_BUILD)\$(DOS).exe /version:5.1 /out:$(DIR_BUILD)\$(PE).exe $(DIR_BUILD)\$(PE).obj kernel32.lib
	echo "Encryptions start here:"
	$(PYTHON) $(DIR_CONFIG)\$(PYSCRIPT) rot_string $(DIR_BUILD)\$(PE).exe "@eset.com"
	$(PYTHON) $(DIR_CONFIG)\$(PYSCRIPT) rc4_region $(DIR_BUILD)\$(PE).exe "CrA" "CrAcKMe2018" "CrAcKMe2018@eset.com" 0xdeadbeef 0xbadb00b5 0xbe57c0de
	$(PYTHON) $(DIR_CONFIG)\$(PYSCRIPT) xor_dos_part $(DIR_BUILD)\$(PE).exe 0xAB 0x400 0xbeef
