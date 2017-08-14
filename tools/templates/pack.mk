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

private recipie : build := \
	#innards

private recipie : install := \
	#innards

private recipie : uninstall := \
	#innards

private recipie : reinstall := \
	#innards

private recipie : purge := \
	#innards

private recipie : deb := \
	#innards

private recipie : tarball := \
	#innards

private recipie : archive := \
	#innards

recipe: ingredients;
	#
	# internals
	#
	#$(if ($(mode), build), $(build),)
	#$(if ($(mode), install), $(install),)
	#$(if ($(mode), uninstall), $(uninstall),)
	#$(if ($(mode), reinstall), $(reinstall),)
	#$(if ($(mode), purge), $(purge),)
	#$(if ($(mode), deb), $(deb),)
	#$(if ($(mode), tarball), $(tarball,)
	#$(if ($(mode), archive), $(archive),)
	$(call mode)
