.PHONY: help test
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --warn-undefined-variables

makefile := ../Makefile
thisfile := $(lastword $(MAKEFILE_LIST))
newfile  := new-Makefile
testdir  := test-of-new-Makefile

include $(makefile)
$(bootstrap): ;

$(newfile): $(thisfile) $(bootstrap) ## Creates new-Makefile from the bootstrap files
	grep -v ^ARCHIVE= $(makefile) >$@
	echo ARCHIVE=\"$$(echo $(bootstrap) | tr ' ' '\n' | cpio --quiet -o | gzip -9 | base64 | tr -d '\n')\" >>$@

release-candidate: test-bootstrap-files test-new-makefile ## Create a release candidate new-Makefile if tests pass
test-bootstrap-files: test ## Runs the bootstrap files tests, before packaging
$(testdir):
	mkdir -p $@
test-new-makefile: $(testdir) $(newfile) ## Packages the bootstrap files, bootstraps, then runs the resulting tests
	$(MAKE) -C $(testdir) -f ../$(newfile) bootstrap test
	rm -rf $(testdir)
help:
	@awk -F":.*## " '$$2&&$$1~/^[a-zA-Z_%-]+/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(thisfile)
