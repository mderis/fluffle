.PHONY: run-dev run-prod build-apk-prod build-appbundle-prod build-ipa-prod codegen codegen-watch regen-env clean l10n rebuild

# Run
run-dev:
	flutter run -t lib/main_dev.dart

run-prod:
	flutter run -t lib/main_prod.dart --release

# Build
build-apk-prod:
	flutter build apk -t lib/main_prod.dart --release

build-appbundle-prod:
	flutter build appbundle -t lib/main_prod.dart --release

build-ipa-prod:
	flutter build ipa -t lib/main_prod.dart --release

# Code Generation
codegen:
	dart run build_runner build --delete-conflicting-outputs

codegen-watch:
	dart run build_runner watch --delete-conflicting-outputs

regen-env:
	dart run build_runner clean
	dart run build_runner build --delete-conflicting-outputs

# Localization
l10n:
	flutter gen-l10n

# Clean
clean:
	flutter clean
	dart run build_runner clean

# Full rebuild
rebuild: clean
	flutter pub get
	$(MAKE) codegen
	$(MAKE) l10n
