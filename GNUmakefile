## detect ARCH for buildx
ARCH                                   :=$(shell uname -m)
export ARCH
ifeq ($(ARCH),x86_64)
TARGET                                 :=amd64
export TARGET
endif
ifeq ($(ARCH),arm64)
TARGET                                 :=arm64
export TARGET
endif

DOCKER=$(shell which docker)
export DOCKER
PWD=$(shell echo `pwd`)
export PWD

-:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?##/ {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
-include Makefile

.PHONY:install
install:
	@rm ./miniscript || true
	@rm /usr/local/bin/miniscript || true
	@$(MAKE) miniscript
	@install $(PWD)/miniscript        /usr/local/bin/
	@install $(PWD)/miniscript-*      /usr/local/bin/

docker:docker-miniscript## 	        docker-build
dockerx:docker-buildx## 	        docker-buildx
docker-build:## 		docker build -f Dockerfile -t miniscript .
	@./miniscript-docker start
	@$(DOCKER) pull ghcr.io/bitcoincore-dev/miniscript-docker:latest
	@$(DOCKER) build -f Dockerfile -t miniscript .
docker-buildx:## 		docker buildx build sequence
	@./miniscript-docker start
	@$(DOCKER) run --privileged --rm tonistiigi/binfmt --install all
	@$(DOCKER) buildx ls
	@$(DOCKER) buildx create --use --name miniscript-buildx || true
	@$(DOCKER) buildx build -t miniscript --platform linux/arm64,linux/amd64 .
	@$(DOCKER) buildx build -t miniscript --platform linux/$(TARGET) . --load
docker-miniscript:docker-build## 		docker-miniscript
	@[[ -z "$(shell file ./miniscript | grep inux)" ]] && echo "not linux" && rm ./miniscript || echo "miniscript is built for linux"
	@$(DOCKER) run --rm -v $(PWD):/src --publish 80:8080  miniscript sh -c "make install"

test:
	@bash $< $@.sh || $(MAKE) miniscript

example-commands:
	@printf "\n"
	@printf "./docker-miniscript \"make miniscript >/dev/null && ls\""
	@printf "\n"
	@printf "./docker-miniscript \"make miniscript >/dev/null && cat 1.miniscript | ./miniscript\""
	@printf "\n"
	@printf "./docker-miniscript \"echo \'thresh(3, pk(key_1), pk(key_2), pk(key_3), older(12960))\' | ./miniscript\""
	@printf "\n"
	@printf "./docker-miniscript \"echo \'and(pk(A),or(pk(B),or(9@pk(C),older(1000))))\' | ./miniscript\""
	@printf "\n"
