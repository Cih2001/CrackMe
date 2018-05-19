DIR_ROOT	:= .
include $(DIR_ROOT)/config/config.mk



all: dos pe

dos: .force
	@$(MAKE) $(MAKE_FLAGS) --directory=$(DIR_DOS)
	
pe: .force
	@$(MAKE) $(MAKE_FLAGS) --directory=$(DIR_WIN)

.force:

clean:
	del build\* /Q