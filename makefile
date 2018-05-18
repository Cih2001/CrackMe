TARGET=CrackMe
DOS=DosStub

all: dos pe

dos: $(DOS).asm
	nasm -f obj $(DOS).asm
	alink -oEXE $(DOS).obj
	
pe:
	nasm -fwin32 $(TARGET).asm
	link /subsystem:console,5.1 /nodefaultlib /entry:main /stub:$(DOS).exe /version:5.1 $(TARGET).obj kernel32.lib


clean:
	del *.obj *.exe