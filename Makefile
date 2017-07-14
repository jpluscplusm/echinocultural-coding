.PHONY: help test bootstrap
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --no-print-directory --warn-undefined-variables

hashbang    := shell
main_script := main
main_func   := functions/main
functions   := $(filter-out $(main_func), $(wildcard functions/*))
tests_make  := tests/Makefile
sources     := $(wildcard $(hashbang) $(main_func) $(functions) $(main_script))
bootstrap   := $(hashbang) $(main_func) functions/example_functions $(main_script) $(tests_make)

script: $(sources) ## Assembles the script
	cat $(sources) >$@
	@chmod u+x $@
-include $(tests_make)
test: ## Runs the tests in tests/Makefile
help:
	@awk -F":.*## " '$$2&&$$1~/^[a-zA-Z_%-]+/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: $(bootstrap) ## Creates a script, function & test skeleton structure
$(bootstrap):
	@echo Creating $@
	@echo $(ARCHIVE) | base64 --decode | gunzip | cpio --quiet -d -i $@
bootstrap-archive:
	echo $(bootstrap) | tr ' ' \\n | cpio --quiet -o | gzip -9 | base64
ARCHIVE="H4sIAIg9aVkCA+WRS0+DQBDHOe+nGLAmbbSyLyDpSQ8eTPTS1HND6bRshKXpLqbG+N3l0Qdpm8jdgbAzP2Yz/5mhEa2e1mhtjFEaSll5UdgQLltO20MwwTkTNGpBSA/GuUkxy5wb1y/N1l8o7aP+BJMSel6D96khQhk2mEWHEkyEq1InVhXa+HmstFN/hiP4JgCYpAV4s1QZqF6bItQ/4XDhHhao9Bq2pYbYwrtWO7AqRxgMDSaFXpq5UTrBOW6KJB09eOTnUrjoKTxqsJDH4cjgJBx3cb7JcH4kzhUB+6aWsUW4uzXXxMg+YrgQexB0NtXMzqCFMZakGZM3ePQuSwS9+mVBu6LuooRFY43/Fn/gSmXo1OEESq3suHZBaYvrbVz33wLzZSzmjU/IMW9CyHlmhTq5VdSqpn8bu05FJ5hNn15en6eu6zr/w34B25wllwAEAAA="
