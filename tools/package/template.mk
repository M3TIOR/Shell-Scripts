#!/usr/bin/make

# CONTRIBUTOR CREDIT LINE
#	notes...
#

# <recipe> should be the name of the package you're making in this repo
# <ingredients> are any files that need to exist for this package to be made
#
#	the recipie's directions are up to you.
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
#

# It's reccomended that you 'can' each of the build modes and use a conditional
# within the actual recipie statement.
#
# for help on canning: https://www.gnu.org/software/make/manual/make.html#Canned-Recipes

# The line:
#	local_path := <relative path to the main script>
# should always be presumed to exist also, since this makefile is loaded
# externally from the main repository makefile and can be used to
# address files within the repo.
#

private template : build := \
	$(if $(call sft_f,d,$(bindir)/template.sh),\
		mkdir -p $(bindir)/template.sh;,);\
	cp -rfu $(srcdir)/template.sh \
		$(bindir)/template;\

private template : install := \
	$(call sudo,\
		cp -rfu
	)

private template : uninstall := \
	#innards

private template : reinstall := \
	#innards

private template : purge := \
	#innards

private template : deb := \
	#innards

private template : tarball := \
	#innards

private template : archive := \
	#innards

template: $(localdir)/.tmp/.init $(srcdir)/template.sh;
	$(call mode)
