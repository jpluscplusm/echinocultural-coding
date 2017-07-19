# Echinocultural coding

Sea urchins are covered in a shell, called a "test", and their commercial
farming is called "Echinoculture".  This project helps you to grow tests around
your shell scripts, to increase their robustness and value.

By using this method from the start of developing a shell script, you can
practise TDD within a shell context, and have confidence a script does what
it's meant to when you modify it.

## Quickstart

*Don't* check out this repository - you just need the Makefile.

Make a directory for your script to live in: when using this method for
developing shell scripts, you'll have more than just a single script file
during development. (The final distributable artifact can be a single file).

The Makefile has a built-in bootstrap mode, which creates a test and function
library directory structure, and some examples of both.

Here's the suggested way to set up your new script in action:

```
$ mkdir a-new-script.sh
$ cd a-new-script.sh
$ wget --quiet https://raw.githubusercontent.com/jpluscplusm/echinocultural-coding/master/Makefile
$ make bootstrap
Creating shell
Creating functions/main
Creating main
Creating functions/examples
Creating tests/examples.mk
Creating tests/unit/bats/examples
Creating tests/unit/shell/examples
$ make test
find tests/unit/shell/ -type f -exec {} \;
Shell tests start
 Numeric test 1 passed
 Numeric test 2 passed
Shell tests passed
if which bats >/dev/null; then find tests/unit/bats/ -type f -exec bats {} + ; fi
 ✓ seconds_since_epoch returns a number
 ✓ seconds_since_epoch increments over time

2 tests, 0 failures
$ make script
cat shell functions/main functions/examples main >script
$ ./script
This is the main function, being run at Unix time 1500448666.
$ cd ..
$ ./a-new-script.sh/script
This is the main function, being run at Unix time 1500448673.
```

All `examples` files can be deleted as soon as you wish, but do remember to
place a new Makefile in `tests/` so that your tests are found and run. See the
section "Adding tests" in this file.

## Development workflow

## Adding tests

## Repackaging the bootstrap archive

NB You don't need to do this. It's for my reference only, or if you want to
distribute a version of the Makefile with different bootstrap contents. This
project is licensed under the GPLv2, as per `LICENSE`.
