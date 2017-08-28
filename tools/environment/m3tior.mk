#!/usr/bin/make

# M3TIOR
#	My personal standards file.
#	This contains every macro I use for building configuration scripts.
#

# mode ?= build			# this line is always assumed to exist
#						# subsequent modes cand be any of...
#
#	build 		- builds the project and outputs it to the repo/BUILD directory
#	install 	- builds and installs the project to it's designated location
#	uninstall 	- removes all files built in with the project
#	reinstall	- uninstalls, builds and installs the package
#	purge		- removes all files associated with the project including those
#				  in user configuration directories
#	deb			- outputs the built project as a .deb package
#	tarball 	- outputs the built project as a .tar archive
#	archive		- outputs the built project as a .ar archive (gnu-make's builtin)
#	test		- runs all tests for the project
#

# This line is here to provide the local filename for use in building the recipies
# this way there's less redundant typing also opening the facility of using
#
#	make <package>
#
# for building packages easier...
override PACKAGE := $(subst .mk,,$(lastword $(subst /,$(SPACE),$(lastword $(MAKEFILE_LIST)))))


private $(PACKAGE) : build := \
	#NOT IMPLEMENTED

private $(PACKAGE) : install := \
	#NOT IMPLEMENTED

private $(PACKAGE) : uninstall := \
	#NOT IMPLEMENTED

private $(PACKAGE) : reinstall := \
	#NOT IMPLEMENTED

private $(PACKAGE) : purge := \
	#NOT IMPLEMENTED

private $(PACKAGE) : deb := \
	#NOT IMPLEMENTED

private $(PACKAGE) : tarball := \
	#NOT IMPLEMENTED

private $(PACKAGE) : archive := \
	#NOT IMPLEMENTED

# NOTE:
#	On building tests... Each test should be hosted within a chroot of the
#	build directory with a symbolic link to the root directory for linking purposes.
#	all projects in this repo should be able to stand on it's own two feet with it's
#	dependencies
#
#	example:
#		@ mkdir -p $(srcdir)/BUILD/shadowroot; $(NEWLINE)\
#		@ mount -o bind,ro / $(srcdir)/BUILD/shadowroot; $(NEWLINE)\
#		TEST='
#
#		';\ # Can't have a newline here because we need to pass TEST
#		chroot '$(srcdir)/BUILD/' "sh -i
#
# NOTE: WARNING!!!
#	Please for the love of god don't forget the --read-only / -o ro,...
#	I killed my last OS three days ago because of that... I tried to rm -rf the
#	BUILD directory while I had mounts to shadowroot / root open... (;-;)
#
private $(PACKAGE) : test := \
	#NOT IMPLEMENTED

$(PACKAGE): init <ingredients>;
	@ # Enable's debugging...
	@ # If you wish to see each line executed simply use:
	@ #
	@ #		make recipie ... debug=true
	@ #
	$(eval private $(PACKAGE): bake = $$($(mode)))
	$(if $(debug),\
		$(subst @,,\
			$(bake)\
		),\
		$(bake)\
	)
