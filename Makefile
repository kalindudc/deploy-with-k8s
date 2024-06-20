.PHONY: build deploy validate-build-subcommand validate-deploy-subcommand help

BUILD_SUBCOMMANDS := python-echo-server
DEPLOY_SUBCOMMANDS := python-echo-server python-echo-server-helm

build deploy: ## Main build target
	@if [ $@ = "build" ] && [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "No subcommand provided for $@. Valid subcommands: $(BUILD_SUBCOMMANDS)"; \
		exit 1; \
	fi

	@if [ $@ = "deploy" ] && [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "No subcommand provided for $@. Valid subcommands: $(DEPLOY_SUBCOMMANDS)"; \
		exit 1; \
	fi
	@echo "$@ with subcommand: $(word 1, $(filter-out $@,$(MAKECMDGOALS)))"
	$(MAKE) $@-$(word 1, $(filter-out $@,$(MAKECMDGOALS)))
	@exit 0

# Pattern rule to match build-<subcommand>
build-%: validate-build-subcommand
	@echo "Running build for $*...\n"
	./scripts/build_image.sh applications/$*
	@exit 0

# Pattern rule to match deploy-<subcommand>
deploy-%: validate-deploy-subcommand
	@echo "Running deploy for $*...\n"
	./scripts/deploy.sh -n $* -d applications/$*/deploy

validate-build-subcommand:
	@$(if $(filter $(MAKECMDGOALS),$(addprefix build-,$(BUILD_SUBCOMMANDS))),,$(error Invalid subcommand "$(MAKECMDGOALS)". Valid subcommands: $(BUILD_SUBCOMMANDS)))

validate-deploy-subcommand:
	@$(if $(filter $(MAKECMDGOALS),$(addprefix deploy-,$(DEPLOY_SUBCOMMANDS))),,$(error Invalid subcommand "$(MAKECMDGOALS)". Valid subcommands: $(DEPLOY_SUBCOMMANDS)))

help:
	@echo "Usage: make <target> [subcommand]"
	@echo ""
	@echo "Targets:"
	@echo "  build <subcommand>       : Build the project"
	@echo "    subcommands: $(BUILD_SUBCOMMANDS)"
	@echo "  deploy <subcommand>      : Deploy the project"
	@echo "    subcommands: $(DEPLOY_SUBCOMMANDS)"
	@echo ""
	@echo "Examples:"
	@echo "  make build foo   : Build 'foo'"
	@echo "  make deploy bar  : Deploy 'bar'"
	@echo ""

# Catch-all target to prevent make from failing with no targets when using a subcommand
%:
	@echo "$(DEPLOY_SUBCOMMANDS) $(BUILD_SUBCOMMANDS)" | grep -q -w "$@" && \
    exit 0 || \
    (echo "Invalid command: $@"; $(MAKE) help)

# Ensure help is the default target if no target is provided
.DEFAULT_GOAL := help
