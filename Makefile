
.PHONY: build-python-echo-server
build-python-echo-server:
	./scripts/build.sh applications/python-echo-server

.PHONY: deploy-python-echo-server
deploy-python-echo-server:
	./scripts/deploy.sh applications/python-echo-server/deploy
