# Include this makefile in your target-specific Makefile.

# In order to work properly, your project Makefile must define the T and OUT
# variable before including this file.

# Other fixed variables
# Use a default build tag when none is set by the caller
NOWDATE         := $(shell date +"%Y%m%d%H%M%S")
#BUILD_TAG       ?= custom_build_$(USER)@$(HOSTNAME)$(NOWDATE)

# Parallelism is handled in sub-makefiles which contain the CPU intensive tasks
.NOTPARALLEL:

KBUILD_OUT_DIR := $(OUT)/kbuild

KCONFIG_HEADER := $(KBUILD_OUT_DIR)/config.h

$(KCONFIG_HEADER): $(KCONFIG_FILE)
	@echo "DATE:" $(NOWDATE)
	@echo "Creating Kconfig header:" $(@:$(T)/%=%)
	$(AT)mkdir -p $(KBUILD_OUT_DIR)
	$(AT)sed $< -e 's/#.*//' > $@
	$(AT)sed -i $@ -e 's/\(CONFIG_.*\)=/#define \1 /'
	# Kconfig uses #define CONFIG_XX 1 instead of CONFIG_XX y for booleans
	$(AT)sed -i $@ -e 's/ y$$/ 1/'

# Provide rules to build the thunderdome "thin" static library built-in.a
# (actually an aggregated list of links to actual object files)

# The framework library (built-in.a) is built based on:
# - the target build configugation -> KCONFIG_FILE,
# - the target build tools -> CC, AR
# - the current CFLAGS and EXTRA_BUILD_CFLAGS
#   if make -C, it is meanning to SRC=(shell cd  $(T))
$(KBUILD_OUT_DIR)/built-in.a: $(KCONFIG_HEADER) FORCE
	@echo "Creating framework archive:" $(OUT:$(T)/%=%)
	$(AT)$(MAKE) -C $(T) -f $(T)/build/Makefile.build \
		SRC=./ \
		OUT=$(KBUILD_OUT_DIR) \
		KCONFIG=$(KCONFIG_FILE) \
		CFLAGS="-include $(KCONFIG_HEADER) $(CFLAGS) $(EXTRA_BUILD_CFLAGS)" \
		CC=$(CC) \
		AR=$(AR)

