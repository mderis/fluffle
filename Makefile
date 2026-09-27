# Common tasks. FLAVOR can be dev (default), staging or prod:
#   make run FLAVOR=staging
FLAVOR ?= dev
ENV_FILE = env/$(FLAVOR).json
FLAVOR_ARGS = --flavor $(FLAVOR) --dart-define-from-file=$(ENV_FILE)

.PHONY: help setup get gen gen-watch l10n analyze format test check run run-release \
        build-apk build-appbundle build-ipa clean

help: ## List available targets
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-16s %s\n", $$1, $$2}'

setup: ## First-time setup: env files from the example, deps, codegen
	@for f in dev staging prod; do [ -f env/$$f.json ] || cp env/example.json env/$$f.json; done
	$(MAKE) get gen

get: ## flutter pub get (also runs gen-l10n)
	flutter pub get

gen: l10n ## Run code generation once
	dart run build_runner build

gen-watch: ## Run code generation in watch mode
	dart run build_runner watch

l10n: ## Generate localizations
	flutter gen-l10n

analyze: ## Static analysis incl. analyzer plugins
	dart analyze --fatal-infos

format: ## Format all Dart code
	dart format lib test

test: ## Run unit and widget tests
	flutter test

check: gen analyze test ## Everything CI runs

run: ## Run the app (FLAVOR=dev|staging|prod)
	flutter run $(FLAVOR_ARGS)

run-release: ## Run a release build on a device
	flutter run --release $(FLAVOR_ARGS)

build-apk: ## Build a release APK
	flutter build apk --release $(FLAVOR_ARGS)

build-appbundle: ## Build a release app bundle for Play
	flutter build appbundle --release $(FLAVOR_ARGS)

build-ipa: ## Build a release IPA
	flutter build ipa --release $(FLAVOR_ARGS)

clean: ## Remove build outputs
	flutter clean
