#created by kamuszhou@tencent.com kamuszhou@qq.com
#website: www.dogeye.net v.qq.com
#Jan 15 2014

projname := $(notdir $(CURDIR))
libname := lib$(projname).a
objs := objs/
deps := deps/
src := src/
libstem := $(projname)
sources := $(wildcard $(src)*.cpp)
objects := $(addprefix $(objs),$(notdir $(subst .cpp,.o,$(sources))))
dependencies := $(addprefix $(deps),$(notdir $(subst .cpp,.d,$(sources))))
include_dir := ./include

CXXFLAGS += 
CPPFLAGS += -I$(include_dir) -g 
LINKFLAGS :=  
LINKFLAGS4TEST := -L./$(bins) -l$(libstem) -Wl,-rpath,. 
MAKECMDGOAL := 
RM := rm -rf
MV := mv
AR := ar rcs 

vpath %.cpp $(src)
vpath %.h . $(include_dir)

.PHONY : clean install dummy

all : $(libname) $(test) 

$(libname) : $(deps) $(objs) $(objects)
	$(AR) $@ $(objects)

# for debug's purpose
dummy:
	#echo $(dependencies)
	
install :
#	-cp $(libname) /usr/local/lib
#	-ln -s /usr/local/lib/$(libname) /usr/lib/$(soname)
 	
$(deps):
	-mkdir $@
 
$(objs):
	-mkdir $@

ifneq "$(MAKECMDGOAL)" "clean"
  -include $(dependencies)
endif

#$(call make-depend,source-file,object-file,depend-file) 
# -MM option causes g++ to omit "system" headers from the prerequisites list.
# This option implies -E which will stop after the preprocessing stage; do not
# run the compiler proper. 
# -MF option specifies the dependecy filename.
# -MT target change the target of the rule emitted by dependency generation.
define make-depend
  g++ -MM -MF $3 -MT $2 $(CPPFLAGS) $(TARGET_ARCH) $1
endef

$(objs)%.o : %.cpp
	$(call make-depend, $<,$@,$(addprefix $(deps),$(subst .cpp,.d,$(notdir $<))))
	$(COMPILE.C) $(OUTPUT_OPTION) $<

clean :
	$(RM) $(objects) $(dependencies) $(libname) $(objs) $(deps)
