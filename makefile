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

# XXX: META-characters
override COMMA := ,
override EMPTY :=
override SPACE := $(EMPTY) $(EMPTY)
override define NEWLINE :=


endef
#
# XXX: this must have two lines to function properly!!!
#

# for help: https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html#Directory-Variables
#
# Script global paths
#
# This is borked atm... :
#ifdef mode
#	$(if ($(mode), build-sys),\
#		prefix ?= / $\
#		mode := build \
#	)
#	$(if ($(mode), build-global),\
#		prefix ?= /usr/ \
#		mode := build \
#	)
#endif
prefix 			?= /usr/local
exec_prefix 	?= $(prefix)
bindir 			?= $(exec_prefix)/bin
sbindir			?= $(exec_prefix)/sbin
libexecdir		?= $(exec_prefix)/libexec
datarootdir		?= $(prefix)/share
datadir			?= $(datarootdir)
sysconfdir		?= $(prefix)/etc
sharedstatedir	?= $(prefix)/com
localstatedir	?= $(prefix)/var
runstatedir		?= $(localstatedir)/run
includedir		?= $(prefix)/include
oldincludedir	?= /usr/include
docdir			?= $(datarootdir)/doc/$(1)
infodir			?= $(datarootdir)/info
htmldir			?= $(docdir)
dvidir			?= $(docdir)
pdfdir			?= $(docdir)
psdir			?= $(docdir)
libdir 			?= $(exec_prefix)/lib
lispdir			?= $(datarootdir)/emacs/site-lisp
localedir 		?= $(datarootdir)/locale
mandir			?= $(datarootdir)/man
srcdir			?= $(PATH_ABSOLUTE)
uninstallerdir	?= $(sysconfdir)/m3tior/uninstall

# NOTE:
# 	this is placed here to ensure all the build directories already exist
#	before we try and do anything stupid, ex: putting shit where it needs to go.
DIRS			= $(prefix) $(exec_prefix) $(bindir) $(sbindir) $(libexecdir) \
				$(datarootdir) $(datadir) $(sysconfdir) $(sharedstatedir) \
				$(localstatedir) $(runstatedir) $(includedir) $(oldincludedir) \
				$(docdir) $(infodir) $(htmldir) $(dvidir) $(pdfdir) $(psdir) \
				$(libdir) $(lispdir) $(localedir) $(mandir) $(uninstallerdir)
$(shell for path in $(DIRS); do mkdir -p $(srcdir)/BUILD/$$path; done;)


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
# this line loads in all the other sub-scripts
include $(candidates)

# Phony targets don't output files
.PHONY: $(targets) all clean list help
#----------------------------------------------------------------------

help: list ;
	@ echo "To build individual packages:"
	@ echo "\t'make <package> <package2> ...'"
	@ echo "or, to build everything:"
	@ echo "\tmake all"
	@ echo "if you wish to install, uninstall, purge, fix, or reinstall a package"
	@ echo "\t'make mode='MODE' <package> ...' Where MODE is one of:"
	@ echo "\t\tbuild\n\t\tbuild-global\n\t\tbuild-sys"
	@ echo "\t\tinstall"
	@ echo "\t\tpurge\n\t\tuninstall\n\t\treinstall"
	@ echo "\t\ttest\n\t\tdeb\n\t\tarchive\n\t\ttarball\n\t\t<custom>..."

list: ;
	@ echo "The current packages available for install in this repository are..."
	@ for package in $(preload_packages); do\
		P=$${package%.mk}; echo "\t$${P##*/}";\
	done;

all: $(targets); @ # Build Everything

clean:
	@ rm -vrf $(PATH_ABSOLUTE)/BUILD
	@ rm -vrf $(PATH_ABSOLUTE)/.tmp/composite
	@ echo "Clean!"
