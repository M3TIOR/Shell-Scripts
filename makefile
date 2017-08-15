#!/usr/bin/make

# M3TIOR 2017
#
#

# Meta character because bork
override comma := ,
override empty :=
override space := $(empty) $(empty)
#Use these for making relative path refferences
override relative_path := $(lastword $(MAKEFILE_LIST))
override filename := $(lastword $(subst /,$(space),$(relative_path)))
override file_path := $(abspath $(relative_path))
override local_path := $(file_path:/$(filename)=$(empty))
#
# Inherited from template script
#--------------------------------------------------------------------

# for help: https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html#Directory-Variables
#
# Script global paths
#
#
ifdef mode
	$(if ($(mode), instal-sys),\
		prefix ?= $(local_path)/BUILD/ \
		mode := install \
	)
	$(if ($(mode), install-global),\
		prefix ?= /usr/ \
		mode := install \
	)
endif
prefix 			?= $(local_path)/BUILD/usr/local
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
srcdir			?= $(local_path)
uninstallerdir	?= $(sysconfdir)/m3tior/uninstall
DIRS			= $(prefix) \
				$(exec_prefix) \
				$(bindir) \
				$(sbindir) \
				$(libexecdir) \
				$(datarootdir) \
				$(datadir) \
				$(sysconfdir) \
				$(sharedstatedir) \
				$(localstatedir) \
				$(runstatedir) \
				$(includedir) \
				$(oldincludedir) \
				$(docdir) \
				$(infodir) \
				$(htmldir) \
				$(dvidir) \
				$(pdfdir) \
				$(psdir) \
				$(libdir) \
				$(lispdir) \
				$(localedir) \
				$(mandir) \
				$(uninstallerdir)
$(shell for path in $(DIRS); do mkdir -p $$path; done;)

#
# Script local EXECUTABLES
#
#override sft_f := $(shell \
#	if [ -$(if \
#		$(findstring $(1),b c d e f g h k p r s u w x O G S),\
#		$(1),\
#		$(error Error: "$(1)" invalid file comparison parameter)) $(2) ];\
#	then echo "true"; fi;\
#)

#override sfc_f := $(shell [ $(2) -$(if $(findstring $(1),nt ot ef),$(1),\
#		$(error Error: "$(1)" invalid file comparison parameter)) $(3) ];\
#	then echo "true"; fi;\
#)

override sudo := \
	{ su -plc '$(1)' $$USER } \
	&& \
	{ echo "Login as superuser failed, exiting" }


# Main segment of script:
# this ensures packages exist before we try and build them
override preload_packages := $(wildcard $(local_path)/tools/package/*.mk)
#----------------------------------------------------------------------

help: list ;
	@ echo "To build individual packages:"
	@ echo "\t'make <package> <package2> ...'"
	@ echo "or, to build everything:"
	@ echo "\tmake all"
	@ echo "if you wish to install, uninstall, purge, fix, or reinstall a package"
	@ echo "\t'make mode='MODE' <package> ...' Where MODE is one of:"
	@ echo "\t\tbuild\n\t\tbuild-global\n\t\tbuild-sys"
	@ echo "\t\tinstall\n\t\tinstall-global\n\t\tinstall-sys"
	@ echo "\n\t\tpurge\n\t\tuninstall\n\t\treinstall"
	@ echo "\t\ttest\n\t\tdeb\n\t\tarchive\n\t\ttarball"

list: ;
	@ echo "The current packages available for install in this repository are..."
	@ for package in $(preload_packages); do\
		P=$${package%.mk}; echo "\t$${P##*/}";\
	done;

override candidates := $(call preload_packages)	# this saves our make targets
override targets := $(foreach target,$(preload_packages),$())
mode ?= build							# as the default, make only builds the projects
include $(candidates)					# this line loads in all the other sub-scripts

all: $(candidates);						# Build Everything

clean:
	@rm -vrf $(local_path)/BUILD
	@rm -vrf $(local_path)/.tmp/composite
	@echo "Clean!"

# Phony targets don't output files
.PHONY: $(candidates) all clean list help
