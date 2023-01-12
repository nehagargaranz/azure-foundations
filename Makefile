SHELL = /bin/bash -e

DIRECTORY := environments
MODULES := $(wildcard modules/*)
STATE_LOCK_PLAN ?= true

define run_command
	$(info >>> Exec ($(1)))
	$(1)
endef

.PHONY: help
help: ## This help output

.PHONY: download
download: ## Download terraform and terragrunt binaries
	$(info --- download)
	@$(call run_command,tgenv install && tfenv install)

.PHONY: format
format: ## Format Terraform and Terragrunt code
format: terraform-format terragrunt-format

.PHONY: terraform-format
terraform-format:
	$(info --- terraform-format)
	@$(call run_command,terraform fmt -recursive)

.PHONY: terragrunt-format
terragrunt-format:
	$(info --- terragrunt-format)
	@$(call run_command,terragrunt hclfmt --terragrunt-working-dir $(DIRECTORY))

.PHONY: lint
lint: ## Lint all Terraform and Terragrunt code
lint: terraform-lint terragrunt-lint tflint yamllint

.PHONY: terraform-lint
terraform-lint:
	$(info --- terraform-lint)
	@$(call run_command,terraform fmt -check -recursive -diff)

.PHONY: terragrunt-lint
terragrunt-lint:
	$(info --- terragrunt-lint)
	@$(call run_command,terragrunt hclfmt --terragrunt-check --terragrunt-working-dir $(DIRECTORY))

.PHONY: yamllint
yamllint:
	$(info --- yamllint)
	@$(call run_command,yamllint -f auto .)

.PHONY: tflint
tflint:
	$(info --- tflint)
	@for module in $(MODULES); do \
		$(MAKE) --no-print-directory tflint-module MODULE=`basename $$module`; \
	done

.PHONY: tflint-module
tflint-module:
tflint-module: module-vars
	$(info --- tflint-module ($(MODULE)))
	@$(call run_command,tflint modules/$(MODULE))

.PHONY: validate
validate: ## Validate all terragrunt modules
	$(info --- validate)
	@$(call run_command,terragrunt run-all validate --terragrunt-non-interactive --terragrunt-include-external-dependencies --terragrunt-working-dir $(DIRECTORY))

.PHONY: clean
clean: ## Remove the .terragrunt-cache directories
	$(info --- clean)
	@$(call run_command,find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;)
	@$(call run_command,rm -fr /opt/terragrunt-cache/*)

.PHONY: docs
docs: ## Generate teraform-docs for all modules
	$(info --- docs)
	@for module in $(MODULES); do \
		$(MAKE) --no-print-directory docs-module MODULE=`basename $$module`; \
	done

.PHONY: docs-module
docs-module: module-vars
	$(info --- docs-module ($(MODULE)))
	@$(call run_command,terraform-docs markdown document --hide requirements --escape=false --sort-by required "modules/$(MODULE)" > "modules/$(MODULE)/README.md")

.PHONY: init-all
init-all: ## Run `terragrunt run-all init` for specifc [DIRECTORY]
	$(info --- init-all ($(DIRECTORY)))
	@$(call run_command,terragrunt run-all init --terragrunt-non-interactive --terragrunt-include-external-dependencies --terragrunt-parallelism 1 --terragrunt-working-dir $(DIRECTORY))

.PHONY: init
init: ## Run `terragrunt init` for specifc [DIRECTORY]
	$(info --- init ($(DIRECTORY)))
	@$(call run_command,terragrunt init --terragrunt-non-interactive --terragrunt-working-dir $(DIRECTORY))

.PHONY: plan-all
plan-all: ## Run `terragrunt run-all plan` for specifc [DIRECTORY]
	$(info --- plan-all ($(DIRECTORY)))
	@$(call run_command,terragrunt run-all plan --terragrunt-non-interactive --terragrunt-include-external-dependencies --terragrunt-working-dir $(DIRECTORY) -lock=$(STATE_LOCK_PLAN))

.PHONY: plan
plan: ## Run `terragrunt plan` for specifc [DIRECTORY]
	$(info --- plan ($(DIRECTORY)))
	@$(call run_command,terragrunt plan --terragrunt-non-interactive --terragrunt-working-dir $(DIRECTORY) -lock=$(STATE_LOCK_PLAN))

.PHONY: apply-all
apply-all: ## Run `terragrunt run-all apply` for specifc [DIRECTORY]
	$(info --- apply-all ($(DIRECTORY)))
	@$(call run_command,terragrunt run-all apply --terragrunt-non-interactive --terragrunt-include-external-dependencies --terragrunt-working-dir $(DIRECTORY))

.PHONY: apply
apply: ## Run `terragrunt apply` for specific [DIRECTORY]
	$(info --- apply ($(DIRECTORY)))
	@$(call run_command,terragrunt apply --terragrunt-non-interactive --terragrunt-working-dir $(DIRECTORY))

# Terragrunt destroy targets
.PHONY: plan-destroy-all
plan-destroy-all: ## Run `terragrunt run-all plan --destroy` for a specific [DIRECTORY]
plan-destroy-all: env-vars
	$(info --- plan-destroy-all ($(DIRECTORY)))
	@$(call run_command,terragrunt run-all plan --destroy --terragrunt-non-interactive --terragrunt-ignore-external-dependencies --terragrunt-working-dir $(DIRECTORY))

.PHONY: destroy-all
destroy-all: ## Run `terragrunt run-all destroy` for specific [DIRECTORY]
	$(info --- destroy-all ($(DIRECTORY)))
	@$(call run_command,terragrunt run-all destroy --terragrunt-non-interactive --terragrunt-ignore-external-dependencies --terragrunt-working-dir $(DIRECTORY))

.PHONY: destroy
destroy: ## Run `terragrunt destroy` for specifc [DIRECTORY]
	$(info --- destroy ($(DIRECTORY)))
	@$(call run_command,terragrunt destroy --terragrunt-non-interactive --terragrunt-ignore-external-dependencies --terragrunt-working-dir $(DIRECTORY))

# Required environment variables when targeting an environment
.PHONY: module-vars
module-vars:
ifndef MODULE
	$(error MODULE is undefined)
endif

help:
	@echo ""
	@echo "Usage: make <target> [parameters]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-38s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Parameters:"
	@echo -e "  \033[36mDIRECTORY=[environment-root-folder]\033[0m    Select the root folder to use for terragrunt execution"
	@echo -e "  \033[36mSTATE_LOCK_PLAN=true\033[0m                   Lock the state file during plans (true/false)"
	@echo ""
	@echo "Examples:"
	@echo -e "  \033[36mmake format\033[0m                            Format all code"
	@echo -e "  \033[36mmake lint\033[0m                              Lint all code"
	@echo -e "  \033[36mmake plan-all DIRECTORY=environments/dev\033[0m  Apply all modules in the \`dev/\` folder"
	@echo -e "  \033[36mmake plan DIRECTORY=environments/dev/australiaeast/vnet\033[0m  Apply specific module"
	@echo -e "  \033[36mmake apply-all DIRECTORY=environments/dev/australiaest\033[0m  Apply all modules in the \`dev/australiaeast/\` folder"
	@echo ""
