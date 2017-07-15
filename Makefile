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
ARCHIVE="H4sIAMFmaVkCA+1UTW/bMAzNdfoVjNcVLTrXlj+B5NIddhjQ7dB1p60oHIephdlKYMldiiL/fZIce4ntNenOY4JEIinykY+SG7vqU4urhVLXjYJAreLIaLyg1rv1n099zwvD0KsVkduI54kM83z0duxUonRmjDvIH0FkxO3m8F6Vg8ZNCupHi4qnki25cIqE8ZH+OTuHZwKAabYE6zZjAtRXZgjaCM2B9zBDxh+grDgkEr5xtgbJCoSTM4Hpks/FvWA8xXtcLdPs/NIimz5w/zjgEa0V4U5zDFyBEmysiEFmnVxZ/RTBMSki6gfxfm8CGkgUUjifk5+4YDmO9HYCFWfS1ktgXOJDmehm1ArxJCQWZk1I6zcBw6ON66RY5ShglkjR7kg3yoTshJkQsn94Qt4sGJ9DDU3ncIyDA7Z8WiEsVDvWmMLzBn5MyV4mdZQt4FfG0gzsGsVU06oo7UTUpm5ArdNRL2Cq/PttDl81gp7fMhmEf0awgToamKDtVM4TiXDxTgxNU3QU1V5QY/BpAyGkfrf6Fknn9mkjIVeGbmsAJZQoq5ILSIBXxQxLy6C+hH6RSv1dzezgbbHAfpBA23mHuwPeuQTP3fHevAhSLUsskCtKl49Ymnv7z0BVam3MEVdApzDsdTfEV6wYiA/zRSPTB78t0I/j3vz/jTD1XDaPBDEv2lftXk87CJmU6qoOFn2Am1ao7jecnm7fS/hSFViy1GQACqtECJxb5EAH21l0XwrnteH6tdSWbZPdw0KHtf7O5vbmw6frjzfj8Xj0X46U36RN04wACAAA"
