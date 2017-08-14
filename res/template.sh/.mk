#!/usr/bin/make

# CREATOR YEAR
#
#	NOTE: about the makefile
#


#These meta characters enable parsing of space and comma in foreach
#		THIS IS AN EVIL LANGUAGE
override comma:= ,
override empty:=
override space:= $(empty) $(empty)
#Use these for making relative path refferences
override relative_path := $(lastword $(MAKEFILE_LIST))
override filename := $(lastword $(subst /,$(space),$(relative_path)))
override file_path := $(abspath $(relative_path))
override local_path := $(file_path:/$(filename)=$(empty))
#override current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path)))


# Phony targets don't output files
.PHONY: build install package purge uninstall reinstall clean

# If no parameter is specified, then the first listed option is built first
# We always want to build the project before deciding on installing it
build: dependencies
	location/to/build/script

install: build
	location/to/install/script

package: build
	location/to/package-builder/script

uninstall:
	location/to/uninstall/script

reinstall: uninstall install

fix: purge install

purge:
	location/to/purge/script

clean:
	@rm -vrf $(current_dir)/BUILD
	@echo "Clean!"
