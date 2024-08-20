################################################################################
# Makefile
################################################################################

#===========================================================
# Check
#===========================================================
ifndef FORCE
    EXP_INFO := sel4devkit-maaxboard-microkit-docker-dev-env 1 *
    CHK_PATH_FILE := /check.mk
    ifeq ($(wildcard ${CHK_PATH_FILE}),)
        HALT := TRUE
    else
        include ${CHK_PATH_FILE}
    endif
    ifdef HALT
        $(error Expected Environment Not Found: ${EXP_INFO})
    endif
endif

#===========================================================
# Layout
#===========================================================
OUT_PATH := out

#===========================================================
# Usage
#===========================================================
.PHONY: usage
usage: 
	@echo "usage: make <target> [FORCE=TRUE]"
	@echo ""
	@echo "<target> is one off:"
	@echo "get"
	@echo "all"
	@echo "clean"

#===========================================================
# Target
#===========================================================
.PHONY: get
get: | ${OUT_PATH}
	git -C ${OUT_PATH} clone --branch "microkit" "git@github.com:seL4/seL4.git" sel4
	git -C ${OUT_PATH}/sel4 reset --hard "4cae30a6ef166a378d4d23697b00106ce7e4e76f"

.PHONY: all
all:

${OUT_PATH}:
	mkdir ${OUT_PATH}

.PHONY: clean
clean:
	rm -rf ${OUT_PATH}

################################################################################
# End of file
################################################################################
