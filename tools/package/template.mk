#!/usr/bin/make

# M3TIOR 2017
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
#	PATH_ABSOLUTE := <relative path to the main script>
# should always be presumed to exist also, since this makefile is loaded
# externally from the main repository makefile and can be used to
# address files within the repo.
#

# This line is here to provide the local filename for use in building the recipies
# this way there's less redundant typing
override package := $(subst .mk,,$(lastword $(subst /,$(SPACE),$(lastword $(MAKEFILE_LIST)))))
$(shell mkdir -p $(TMP)/template.sh) # init a new temp folder specific to this package

private $(package) : build = \
	@ \
	VERSION=$$(git log --pretty=format:"%H" $(srcdir)/template.sh.php); \
	GLOBAL_PATH=$(datadir)/m3tior/template.sh; \
	php -f $(srcdir)/template.sh.php -- \
		--version=$$VERSION \
		--global-data=$$GLOBAL_PATH \
	> $(bindir)/template; $(NEWLINE)\
	@ mkdir -p $(datadir)/m3tior/template.sh; $(NEWLINE)\
	@ cp -rfu \
		$(foreach data,\
			$(wildcard $(srcdir)/res/template/*), $(data)) \
		$(datadir)/m3tior/template.sh;

private $(package) : install := \
	#NOT IMPLEMENTED

private $(package) : uninstall := \
	#NOT IMPLEMENTED

private $(package) : reinstall := \
	#NOT IMPLEMENTED

private $(package) : purge := \
	#NOT IMPLEMENTED

private $(package) : deb := \
	#NOT IMPLEMENTED

private $(package) : tarball := \
	#NOT IMPLEMENTED

private $(package) : archive := \
	#NOT IMPLEMENTED

private $(package) : test := \
	#NOT IMPLEMENTED

$(package): init $(PATH_ABSOLUTE)/src/template.sh.php
	$(eval private $(package): bake = $$($(mode)))
	$(if $(debug),\
		$(subst @,,\
			$(bake)\
		),\
		$(bake)\
	)
