MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --no-print-directory --warn-undefined-variables
makefile := ../Makefile
thisfile := $(lastword $(MAKEFILE_LIST))

include $(makefile)

$(bootstrap): ;
new-Makefile: $(thisfile) $(bootstrap)
	@grep -v ^ARCHIVE= $(makefile) > $@
	@echo ARCHIVE=\"$$(echo $(bootstrap) | tr ' ' '\n' | cpio --quiet -o | gzip -9 | base64 | tr -d '\n')\" >> $@
