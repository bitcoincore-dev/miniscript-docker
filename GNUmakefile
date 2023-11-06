ifeq ($(project),)
PROJECT_NAME                            := $(notdir $(PWD))
else
PROJECT_NAME                            := $(project)
endif
export PROJECT_NAME
VERSION                                 :=$(shell cat version)
export VERSION
TIME                                    :=$(shell date +%s)
export TIME

OS                                      :=$(shell uname -s)
export OS
OS_VERSION                              :=$(shell uname -r)
export OS_VERSION
ARCH                                    :=$(shell uname -m)
export ARCH
ifeq ($(ARCH),x86_64)
TRIPLET                                 :=x86_64-linux-gnu
export TRIPLET
endif
ifeq ($(ARCH),arm64)
TRIPLET                                 :=aarch64-linux-gnu
export TRIPLET
endif
ifeq ($(ARCH),arm64)
TRIPLET                                 :=aarch64-linux-gnu
export TRIPLET
endif

HOMEBREW                                :=$(shell which brew || false)

PANDOC                                  :=$(shell which pandoc || false)

RUSTUP_INIT_SKIP_PATH_CHECK=yes
TOOLCHAIN=stable
Z=	##
ifneq ($(toolchain),)

ifeq ($(toolchain),nightly)
TOOLCHAIN=nightly
Z=-Z unstable-options
endif

ifeq ($(toolchain),stable)
TOOLCHAIN=stable
Z=	##
endif

endif

## Submission workflow:
##	
## 1. Add your template to the TEMPLATES list
## 2. Add your template to the TOC.mediawiki
## 3. make && make serve
## 4. Check html is rendered correctly
## 5. Submit pull request

TEMPLATES:=\
MinT-000 \
MinT-001 \
MinT-002 \
MinT-003 \
MinT-004 \

TEMPLATES_MD:=\
README.md \
MinT-000.md \
MinT-001.md \
MinT-002.md \
MinT-003.md \
MinT-004.md \

.PHONY:-
-:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?##/ {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo
more:## 	more help
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/	/'
all:README $(TEMPLATES) $(TEMPLATES_MD)## 	make README $(TEMPLATES) Mint-**
#$(MAKE) -f Makefile help
serve:## 	serve
	@. serve 2>/tmp/serve.log


# Example command:
# docker \
	run \
	--rm \
	--volume "`pwd`:/data" \
	--user `id -u`:`id -g` \
	pandoc/latex:2.6 \
	--preserve-tabs \
	--ascii \
	--from=mediawiki \
	--to=html \
	README.mediawiki | sed 's/__NOTOC__//' > readme.html
	
README:## 	README
	@command -v pandoc >/dev/null 2>&1 && \
		pandoc --preserve-tabs --ascii --from=markdown --to=html $@.md | \
		sed 's/__NOTOC__//' > index.html || command -v docker && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.md
	
TOC:## 	TOC
	@command -v pandoc >/dev/null 2>&1 && \
		pandoc --preserve-tabs --ascii --from=markdown --to=html $@.md | \
		sed 's/__NOTOC__//' > TOC.html || command -v docker && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.md

# @type -P pandoc >/tmp/miniscript-template.log && \
# 	pandoc --preserve-tabs --from=mediawiki --to=markdown $@.mediawiki | \
# 	sed 's/__NOTOC__//' > readme.html || type -P docker && docker pull pandoc/latex:2.6 && \
# 	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 --preserve-tabs --ascii --from=mediawiki --to=html $@.mediawiki | sed 's/__NOTOC__//' > $@.html
#
# @type -P pandoc >/tmp/miniscript-template.log && \
# 	pandoc --preserve-tabs --from=mediawiki --to=markdown $@.mediawiki | \
# 	sed 's/__NOTOC__//' > README.md || type -P docker && docker pull pandoc/latex:2.6 && \
# 	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 --preserve-tabs --ascii --from=mediawiki --to=markdown $@.mediawiki

$(TEMPLATES).%:## 	$(TEMPLATES)
	@command -v pandoc >/dev/null 2>&1 && \
		pandoc --preserve-tabs --ascii --from=mediawiki --to=html $@.mediawiki | \
		sed 's/__NOTOC__//' > $@.html || command -v docker 2>/dev/null && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.mediawiki

$(TEMPLATES_MD).%:## 	$(TEMPLATES_MD)
	@command -v pandoc >/dev/null 2>&1 && \
		pandoc --preserve-tabs --ascii --from=markdown --to=html $@.md | \
		sed 's/__NOTOC__//' > $@.html || command -v docker 2>/dev/null && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.md


.PHONY: report
report:## 	make variables
	@echo ''
	@echo 'TIME=${TIME}'
	@echo 'PROJECT_NAME=${PROJECT_NAME}'
	@echo 'VERSION=${VERSION}'
	@echo ''
	@echo 'OS=${OS}'
	@echo 'OS_VERSION=${OS_VERSION}'
	@echo 'ARCH=${ARCH}'
	@echo ''
	@echo 'HOMEBREW=${HOMEBREW}'
	@echo 'PANDOC=${PANDOC}'
	@echo ''
	@echo 'TEMPLATES=${TEMPLATES}'

checkbrew:## 	install brew command
ifeq ($(HOMEBREW),)
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	@type brew && brew install pandoc
	@type brew && brew install emscripten
	@type brew && brew install --cask docker
endif

submodules:## 	submodules
	@git submodule update --init --recursive

.PHONY:$(TEMPLATES) serve

-include docker.mk
