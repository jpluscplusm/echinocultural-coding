.PHONY: help test bootstrap
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --warn-undefined-variables

hashbang    := shell
main_script := main
main_func   := functions/main
functions   := $(filter-out $(main_func), $(wildcard functions/*))
tests_make  := tests/Makefile
sources     := $(wildcard $(hashbang) $(main_func) $(functions) $(main_script))

script: $(sources) ## Assembles the script
	cat $(sources) >$@
	@chmod u+x $@
-include $(tests_make)
test: ## Runs the tests in tests/Makefile
help:
	@awk -F":.*## " '$$2&&$$1~/^[a-zA-Z_%-]+/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap := $(hashbang) $(main_func) $(main_script) $(tests_make)
bootstrap += functions/examples tests/unit/bats/examples tests/unit/shell/examples
bootstrap: $(bootstrap) ## Creates a script, function & test skeleton structure
$(bootstrap):
	@echo Creating $@
	@echo $(ARCHIVE) | base64 --decode | gunzip | cpio --quiet -d -i $@
bootstrap-archive:
	@echo $(bootstrap) | tr ' ' '\n' | cpio --quiet -o | gzip -9 | base64 | tr -d '\n'; echo
ARCHIVE="H4sIAGFpaVkCA+1U32/aMBDmdf4rjqyrWnU0sfNLAmnqHvYwadtD1z1tVRXCQawlBsUOo6r432c7kAHJCt3zDgT2+Xz33X139mJPf2rxjFDqeVEQ6FUcWQ0Lar1X//nUZywMQ1YrIm8rjMkM87z3uu9WsnTHXLgoliAz4h3GYC+KQeNtCOpH00qkis+FdIuEi575ubiEJwKAaTYH5y7jEvRXZQjmELYX3sIYuZhBWQlIFHwTfAWKFwhnFxLTuZjIB8lFig+4mKfZ5bVD1m3g/mnAI1orwp3iWLgSFQywIhaZc3bjtEMEp4SIgpDF+7UJWKBQKul+Tn7ilOfYM9shVIKrgVkCFwpnZWKKUSvko1RY2DUhjd0QLI8DXCXFIkcJ40TJZkcOvQzJjpshIfuXh+TVlIsJ1NBMDNcauDBQjwuEqS7HClN4WsOPEdmLpK/yKfzKeJpZCPDOneDSFVWejwy9mtoDz8bq0LG9qb1fwUjbt8sdvqgVmd8wGoR/WnELudfRSZvunCQK4eqN7Oqq6CTKWVBj8OkWQkj9w+wbJAdTaA4JubG0Ox0ooURVlUJCAqIqxlg6FvU1tJPU6u+6dzunxoHBTAFt+h7uj1jnCpi3Y71+FqRellig0JTOl1ja+f1noDq0OcwRF0BH0G1138VXrBmIj/NFI1sHv0nQj+PWHPyNMP1sbh8LYl+2r8a87naQKin1yHYmfYSbRqipN5yfb95N+FIVWPLURgAKi0RKnDjkSAWbXvSec8cad+1c6pNNkb3jQru1/s7m7vb9x08fbvv9fu+/HJHfwx5bOwAIAAA="
