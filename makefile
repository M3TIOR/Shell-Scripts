#!/usr/bin/make

# M3TIOR 2017
#
#

# NOTE:
#	Because some essential variables exist, I need a facility to make
#	them more prominent than standard variables. so (very complex much wow)
#	I'm just making all of them UPPERCASE horray right! so easy to read!
#	also it's less likely you'll accidentally name a variable like it since
#	most people don't like to type with caps-lock on.
#

# NOTE: PATH AND FILE REFFERENCES
override FILE_RELATIVE := $(lastword $(MAKEFILE_LIST))
override FILE_ABSOLUTE := $(abspath $(FILE_RELATIVE))
override FILE := $(lastword $(subst /,$(SPACE),$(FILE_RELATIVE)))
override PATH_RELATIVE := $(subst $(FILE),,$(FILE_RELATIVE))
override PATH_ABSOLUTE := $(FILE_ABSOLUTE:/$(FILE)=$(EMPTY))

include $(PATH_ABSOLUTE)/tools/metachar.mk

# NOTE: GNU-STD deviation;
#	I'm the type of person who crave's reproducibilty.
#	So I'm enforcing a strict law that all files must be
#	built en stage, before being installed.
#
#	This way users are also able to test an app in one location
#	to see if it's to their liking before actually installing it on
#	their machine.
include $(PATH_ABSOLUTE)/tools/gnu-std.mk
stage := $(PATH_ABSOLUTE)/BUILD
installdir := $(prefix)
prefix := $(stage)/$(prefix)
srcdir := $(PATH_ABSOLUTE)/src


override TMP := $(shell \
	if type mktemp > /dev/null 2>&1; then\
		if mktemp -d --quiet; then\
			return 0;\
		fi;\
	fi;\
	mkdir -p $(PATH_ABSOLUTE)/.tmp;\
	echo $(PATH_ABSOLUTE)/.tmp;\
)
$(shell echo "$(TMP)" >> $(PATH_ABSOLUTE)/.tmplist)

# NOTE:
# 	this is placed here to ensure all the build directories already exist
#	before we try and do anything stupid, ex: putting shit where it needs to go.
# 	it's used within the 'init' recipie
DIRS			= $(prefix) $(exec_prefix) $(bindir) $(sbindir) $(libexecdir) \
				$(datarootdir) $(datadir) $(sysconfdir) $(sharedstatedir) \
				$(localstatedir) $(runstatedir) $(includedir) $(oldincludedir) \
				$(docdir) $(infodir) $(htmldir) $(dvidir) $(pdfdir) $(psdir) \
				$(libdir) $(lispdir) $(localedir) $(mandir) $(uninstallerdir)


# Main segment of script:
# this ensures packages exist before we try and build them
override preload_packages := $(wildcard $(PATH_ABSOLUTE)/tools/package/*.mk)

override candidates := $(call preload_packages)	# this saves our make targets
override targets := \
	$(foreach target,$(candidates),\
		$(subst .mk,$(EMPTY),\
			$(lastword $(subst /,$(SPACE),$(target)))\
		)\
	)
# as the default, make only builds the projects
# XXX: borked, seriously this syntax is killer...
#		for some reason this won't work if you add whitespace before
#		a comment. I'm assuming what's happening is the variable is being
#		saved with the trailing whitespace... It should trim... ugh...
export mode ?= build
export savetemp ?=
export debug ?=
# this line loads in all the other sub-scripts
include $(candidates)

# Phony targets don't output files
.PHONY: $(targets) init all clean list help build
#----------------------------------------------------------------------

init: ;
	$(shell \
		for path in $(DIRS); do \
			mkdir -p $$path; \
		done;\
	)

help: list ;
	@ echo "To build individual packages:"
	@ echo "\t'make <package> <package2> ...'"
	@ echo "or, to build everything:"
	@ echo "\tmake all"
	@ echo "if you wish to install, uninstall, purge, fix, or reinstall a package"
	@ echo "\t'make mode='MODE' <package> ...' Where MODE is one of:"
	@ echo "\t\tbuild\n\t\tinstall"
	@ echo "\t\tpurge\n\t\tuninstall\n\t\treinstall"
	@ echo "\t\ttest\n\t\tdeb\n\t\tarchive\n\t\ttarball\n\t\t<custom>..."

list: ;
	@ echo "The current packages available for install in this repository are..."
	@ for package in $(preload_packages); do\
		P=$${package%.mk}; echo "\t$${P##*/}";\
	done;

all: init $(targets); @ # Build Everything

clean:
	@ # This just reads mtab for mouted directories within the jail
	@ # and unmounts them. Because I really don't want to kill my OS
	@ # By accident again...
	@ while read line; do \
		set - $$line; \
		if [ "$${2##$(PATH_ABSOLUTE)/BUILD*}" = '' ]; then \
			if ! umount $$2; then exit 1; fi; \
		fi; \
	done < /etc/mtab;
	@ rm -vrf $(PATH_ABSOLUTE)/BUILD;
	@ if [ -e $(PATH_ABSOLUTE)/.tmplist ]; then \
		while read file; do \
			rm -vrf $$file; \
		done < $(PATH_ABSOLUTE)/.tmplist; \
		rm $(PATH_ABSOLUTE)/.tmplist; \
	fi;
	@ echo "Clean!";


# Clean up extra mounted directories after execution as a cautionary measure
$(shell \
	while read line; do \
		set - $$line; \
		if [ "$${2##$(PATH_ABSOLUTE)/BUILD*}" = '' ]; then \
			if ! umount $$2; then exit 1; fi; \
		fi; \
	done < /etc/mtab; \
)

ifndef savetemp
$(shell \
	if [ -e $(PATH_ABSOLUTE)/.tmplist ]; then \
		while read file; do \
			rm -vrf $file; \
		done < $(PATH_ABSOLUTE)/.tmplist; \
		rm $(PATH_ABSOLUTE)/.tmplist; \
	fi; \
)
endif
