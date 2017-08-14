
ifdef mode
	variable := stuff
endif
#$(if ($(mode),derp), variable := yes, variable := no)

test: ;
	@ echo $(variable)
