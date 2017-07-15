test: unit-test integration-test system-test

unit-test: shell-examples bats-examples
integration-test:
system-test:

shell-examples:
	find tests/unit/shell/ -type f -exec {} \;
bats-examples:
	if which -s bats; then find tests/unit/bats/ -type f -exec bats {} + ; fi
