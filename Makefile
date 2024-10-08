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
DEP_PATH := dep
TMP_PATH := tmp
OUT_PATH := out

DEP_SL4_PATH := ${DEP_PATH}/sel4

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
	@echo "reset"

#===========================================================
# Target
#===========================================================
ifneq ($(wildcard ${OUT_PATH}/microkit-sdk-1.4.1),)

.PHONY: get
get:

.PHONY: all
all:

else

.PHONY: get
get: dep-get ${TMP_PATH}/microkit

${TMP_PATH}/microkit: | ${TMP_PATH}
	git -C ${TMP_PATH} clone --branch "main" "git@github.com:seL4/microkit.git" microkit
	git -C ${TMP_PATH}/microkit reset --hard "395cf0e5be489bbd7586b012188fc1f712cd1a57"
	# Adjust to use GCC 12.
	sed --in-place --expression "s/aarch64-none-elf/aarch64-linux-gnu/g" ${TMP_PATH}/microkit/build_sdk.py ${TMP_PATH}/microkit/example/maaxboard/hello/Makefile

.PHONY: dep-get
dep-get:
	make -C ${DEP_SL4_PATH} get

# Prefer relative. Only use where absolutely essential.
ROOT_PATH := $(shell dirname $(realpath $(firstword ${MAKEFILE_LIST})))

.PHONY: all
all: dep-all ${OUT_PATH}/microkit-sdk-1.4.1

.PHONY: dep-all
dep-all:
	make -C ${DEP_SL4_PATH} all

${TMP_PATH}:
	mkdir ${TMP_PATH}

${OUT_PATH}:
	mkdir ${OUT_PATH}

${OUT_PATH}/microkit-sdk-1.4.1: ${TMP_PATH}/microkit/release/microkit-sdk-1.4.1 | ${OUT_PATH}
	cp -r $< $@

${TMP_PATH}/microkit/release/microkit-sdk-1.4.1: ${DEP_SL4_PATH}/out/sel4 | ${TMP_PATH}/microkit ${TMP_PATH}
	# Python.
	python -m venv ${TMP_PATH}/pyenv
	. ${TMP_PATH}/pyenv/bin/activate ; pip install --requirement ${TMP_PATH}/microkit/requirements.txt
	# Build.
	. ${TMP_PATH}/pyenv/bin/activate ; cd ${TMP_PATH}/microkit ; python build_sdk.py --sel4=${ROOT_PATH}/${DEP_SL4_PATH}/out/sel4 --skip-docs --boards maaxboard

endif

.PHONY: clean
clean:
	make -C ${DEP_SL4_PATH} clean
	rm -rf ${TMP_PATH}

.PHONY: reset
reset: clean
	rm -rf ${OUT_PATH}

################################################################################
# End of file
################################################################################
