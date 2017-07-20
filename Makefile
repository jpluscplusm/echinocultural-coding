# Copyright (C) 2017 Jonathan Matthews.
# License: GNU General Public License version 2.
# See LICENSE.txt and LICENSE

.PHONY: help test bootstrap clean clean-bootstrap
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --warn-undefined-variables

hashbang    := shell
main_script := main
main_func   := functions/main
functions   := $(filter-out $(main_func), $(wildcard functions/*))
MOCKS       ?=
mocks       ?= $(wildcard $(MOCKS))
sources     := $(wildcard $(hashbang) $(main_func) $(functions) $(mocks) $(main_script))

script: $(sources) ## Assembles the script
	cat $(sources) >$@
	@chmod u+x $@
test:
-include tests/*.mk
clean: clean-bootstrap ## Removes the script for e.g. after a mocked version has been built
	rm -f script
help:
	@awk -F":.*## " '$$2&&$$1~/^[a-zA-Z_%-]+/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap := $(hashbang) $(main_func) $(main_script) functions/examples
bootstrap += tests/examples.mk tests/unit/bats/examples tests/unit/shell/examples
bootstrap: $(bootstrap) ## Creates a script, function & test skeleton structure
$(bootstrap):
	@echo Creating $@
	@echo $(ARCHIVE) | base64 --decode | gunzip | cpio --quiet -d -i $@
-include bootstrap-generator.mk
ARCHIVE="H4sIAGhialkCA+1U32/aMBDmdf4rjqyrWnWQ2PklgTR1D3uoNO2h6562qgrhINYSg2Kno6r432c7JKWQAdvzDgT2+Xz3+bvP9mJPf2rzjFHqeVEQ6FEcWQ8Lar9X//nUZywMQ1Y7Iq8xxmSGed5723crWboTLlwUjyAz4u3WYCfUCGhEPd9O46YE9aNZJVLFF0K6RcJFz/xcXMIzAcA0W4Bzl3EJ+qsyBLMIzYb3MEEu5lBWAhIF3wRfgeIFwtmFxHQhpvJBcpHiAy4XaXY5dMh6H7h/CnCNO6zn4RY5Fq5EBQOsiEXmnF07+yWCv+Kf+W2JIHzhBldJscxR9jqOtqFrmiiEq3ey65jhKRiiIGT1ImshsEChVC/1h8XPnvGMoBJcDcwQuFA4LxMDtHbIJ6mwsGNC2rgRWDkNmlQwSZRsZ2Q3y4hspRkR8nrziLyZcTGFGp2p4doAFwbqaYkw011ZYQrPa/gxJq8q6a18Br8ynmYWAnxwp/joiirPx0ZlWmE7mU3UbmK7U2e/grGO32c8OolxFtRd92nDeEj93cpt73cuolkk5NpS7nToAkpUVSkkJCCqYoKlY3UyhH1Zafd3Ld/Oi+PAYK6AttKH+yPRuYJWQCZ6fRCkHpZYoNB0Lh6xtFf4n4Hq0mYxR1wCHUN31H3XDYl1B+Lj/aKR5cFvD+jH8Z4G/9Qw/XI27wWxj9tXE14rDaRKSn1dOg99pDetUcM3nJ9vnk74UhVY8tRWAArLREqcOuQIg60WvUPpWJtu/yz1yoZk77jRbq+/Nbm7/Xjz+dNtv9/v/bdD9hvWNgYDAAgAAA=="
