.PHONY: clean release

candidate := release-candidate
testdir   := $(candidate)-test
thisfile  := $(lastword $(MAKEFILE_LIST))

release: $(candidate)
	cp $(candidate) Makefile

$(candidate): $(bootstrap) $(thisfile)
	grep -v ^ARCHIVE= Makefile >$@
	echo ARCHIVE=\"$$(echo $(bootstrap) | tr ' ' '\n' | cpio --quiet -o | gzip -9 | base64 | tr -d '\n')\" >>$@
	mkdir -p $(testdir)
	mv $@ $(testdir)/
	$(MAKE) -C $(testdir) -f $@ bootstrap
	$(MAKE) -C $(testdir) -f $@ test
	mv $(testdir)/$@ .
	rm -rf $(testdir)

clean:
	rm -rf $(candidate) $(testdir)
