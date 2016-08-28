ifeq ($(origin OUTPUT), undefined)
	OUTPUT := Debug
endif

TOP_DIR := $(shell pwd)

export TOP_DIR

all:$(SUBDIR)

$(SUBDIR):
	set -e;mkdir -p $(OUTPUT)/$@/; \
	$(MAKE) -C $(OUTPUT)/$@/ SRC=$(TOP_DIR)/$@ -f $(TOP_DIR)/$@/Makefile all

clean:
	$(RM) -rf $(OUTPUT)/*

.PHONY: all clean $(SUBDIR)