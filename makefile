DIR_ROOT	:= .
include $(DIR_ROOT)/config/config.mk

all: clean dos pe floppy

dos: .force
	@$(MAKE) $(MAKE_FLAGS) --directory=$(DIR_DOS)
	
pe: .force
	@$(MAKE) $(MAKE_FLAGS) --directory=$(DIR_WIN)

floppy:	.force
	$(BFI) -f=$(DIR_DEBUG)\$(FLOPPY) $(DIR_BUILD)

debug: floppy .force
	bochs -f $(DIR_CONFIG)\bochsrc.cfg

.force:

clean:
	del $(DIR_BUILD)\* /Q
	del $(DIR_DEBUG)\$(FLOPPY)