.PHONY: help test bootstrap
.DEFAULT_GOAL := help
MAKEFLAGS     += --no-builtin-rules --no-builtin-variables --no-print-directory --warn-undefined-variables

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
ARCHIVE="H4sIAFloaVkCA+1U32/aMBDmdf4rjqyrWnVp4vyUQJq6hz1U2vbQdU9bVYVwgLXEoNipqCr+99kOySDJgO55BwL7fL7v831nu7GrPpW52ih13SgI1CiOjMcLKr9b/fnU97wwDL3KEbm1eZ5YYJYN3g6dUhTOhHEH+ROIBXHbGN6rMGhcQ1A/mpU8lWzJhZMnjA/0z8UlvBAATBdLsO4XTID6ygWCXoR6w3uYIONzKEoOiYTvnK1Bshzh7EJguuRT8SgYT/ERV8t0cXltkU2XuH8a8YhWjnCnOIauQAk2lsQws85urC5EcApEFFDq79cm8F2JQgrnS/ILZyzDgZ6OoORM2noIjEucF4kuRuUQz0JibsaENHEjMDrauE7yVYYCJokUzYy0s4zITpoRIfubR+TNjPEpVNQ0hmMCHLDl8wphpsqxxhReNvBzTPaQ1FY2M+Bg209YCIUIH5wpPjm8zLKxlljJ28qu49vJTQ6FcAVjFd8tefiqdvT8RtUg/NOONe1BTzdtO3SaSISrd6Kvs6KTZPeCioNPawoh9dunb5i0bqJeJOTGSG/1sIQCZVlwAQnwMp9gYRnW19A9pHL/UP3be3MssOcSaNP78HAkOpPguTvRm4Mk1bDAHLmSdKm6wtzhfyaqoPVihrgCOob+qIc+vWKlQHxcLxqZOvjNAf047tyFvwmmns76wSDmdfumw6tuByGTQl3b3kMf0aYxqusN5+fbtxO+ljkWLDUIQGGVCIFTixypYNOL7qF0XpOue5ZqZVtk97jRfq+/M7m/+3j7+dPdcDgc/LcD9hsli14UAAgAAA=="
