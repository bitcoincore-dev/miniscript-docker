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
## #
## 1. Add your template to the TEMPLATES list
## 2. Add your template to the TOC.mediawiki
## 3. make
## 4. Check html is rendered correctly
## 5. Submit pull request

TEMPLATES:=\
TOC \
MinT-000-Timelocks-in-Templates \
MinT-001-3-Key-Time-Layered-Multisig \
MinT-002-5-Time-Layered-Multisig \
MinT-003-Multi-Institutional-Custody-One-Agent \
MinT-004-Multi-Institutional-Custody-Two-Agents \

-:README $(TEMPLATES)

serve:
	@. serve 2>/tmp/serve.log


## Example command:
## docker \
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

README:
	@type -P pandoc >/tmp/miniscript-template.log && \
		pandoc --preserve-tabs --ascii --from=markdown --to=html $@.md | \
		sed 's/__NOTOC__//' > index.2.html || type -P docker && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.md
	 
	## @type -P pandoc >/tmp/miniscript-template.log && \
	## 	pandoc --preserve-tabs --from=mediawiki --to=markdown $@.mediawiki | \
	## 	sed 's/__NOTOC__//' > readme.html || type -P docker && docker pull pandoc/latex:2.6 && \
	## 	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 --preserve-tabs --ascii --from=mediawiki --to=html $@.mediawiki | sed 's/__NOTOC__//' > $@.html
	##  
	## @type -P pandoc >/tmp/miniscript-template.log && \
	## 	pandoc --preserve-tabs --from=mediawiki --to=markdown $@.mediawiki | \
	## 	sed 's/__NOTOC__//' > README.md || type -P docker && docker pull pandoc/latex:2.6 && \
	## 	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 --preserve-tabs --ascii --from=mediawiki --to=markdown $@.mediawiki

$(TEMPLATES).%:
	@type -P pandoc >/tmp/miniscript-template.log && \
		pandoc --preserve-tabs --ascii --from=mediawiki --to=html $@.mediawiki | \
		sed 's/__NOTOC__//' > $@.html || type -P docker && docker pull pandoc/latex:2.6 && \
		docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex:2.6 $@.mediawiki


.PHONY: report
report:## 	print make variables
##	print make variables
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

checkbrew:## 	install brew command
##	install brew, pandoc and docker --cask
ifeq ($(HOMEBREW),)
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	@type -P brew && brew install pandoc
	@type -P brew && brew install emscripten
	@type -P brew && brew install --cask docker
endif

.PHONY:$(TEMPLATES) serve
