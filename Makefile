#>>>Build dir
T   ?=$(shell 'pwd')
OUT ?=$(T)/out
OUTPUT_DIR ?=$(T)/out


$(info Build PATH****************************************)
$(info )
$(info T:$(T))
$(info OUT:$(OUT))
$(info )
$(info Build PATH****************************************)
$(info )

#>>>Build tools
export CC =  gcc
export AT        := $(if $(VERBOSE),,@)
export MAKE = make
export AR = gcc-ar

#>>>Build_flags
export EXTRA_BUILD_CFLAGS =
CFLAGS := -g

#>>>Add header file
CFLAGS += -I$(T)/main_code/include

#>>>Kconfig file
KCONFIG_FILE = $(T)/config/Kconfig
include $(KCONFIG_FILE)

#>>>Make start
all: $(OUT)/test.bin

$(OUT)/test.bin:$(OUTPUT_DIR)/kapp/libkbuildout.a
	gcc -o $(OUT)/test.bin $(OUTPUT_DIR)/kapp/libkbuildout.a

# This rule just to put the library where the Zephyr build expects to find it
#	built-in.a -> kapp/libkbuildout.a
$(OUTPUT_DIR)/kapp/libkbuildout.a: $(OUT)/kbuild/built-in.a
	@echo "Preparing framework archive for sherlock kbuild"
	$(AT)install -d $(OUTPUT_DIR)/kapp
	$(AT)rm -f $@
	$(AT)$(AR) -rcT $@ $<


include $(T)/build/base.mk


clean:
	rm -rf  $(OUT)

#>>>Create a tag important
.PHONY: FORCE all
