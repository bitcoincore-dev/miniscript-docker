DOCKER=$(shell which docker)
export DOCKER
PWD=$(shell echo `pwd`)
export PWD

-:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?##/ {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
-include Makefile

docker:docker-miniscript## 	        docker-build
	install $(PWD)/miniscript-run    /usr/local/bin/
	install $(PWD)/miniscript-docker /usr/local/bin/
docker-build:## 		docker build -f Dockerfile -t miniscript .
	$(DOCKER) build -f Dockerfile -t miniscript .
docker-miniscript:docker-build## 		docker-miniscript
	@[[ -z "$(shell file ./miniscript | grep inux)" ]] && echo "not linux" && rm ./miniscript || echo "miniscript is built for linux"
	$(DOCKER) run --rm -v $(PWD):/src   miniscript sh -c "make miniscript"
	$(DOCKER) run --rm -v $(PWD):/src   miniscript sh -c "install miniscript /usr/local/bin/ && which miniscript"

.PHONY:test-command
test-command:
	@cat $< $@ && exit;

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
