SHELL := /bin/bash -euo pipefail

GITHUB_REPO ?= "makkes/ghactions-playground.git"
GITHUB_USER ?=
GITHUB_TOKEN ?=
GIT_COMMIT := $(shell git rev-parse "HEAD^{commit}")
GIT_TAG ?= $(shell git describe --tags --abbrev=7 "$(GIT_COMMIT)^{commit}" --exact-match 2>/dev/null)
GIT_CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

HELM_RELEASE_PACKAGE_DIR ?= .helm-release-packages

.PHONY: bump-version
bump-version:
ifeq (,$(GIT_TAG))
	$(error "Please set GIT_TAG")
endif
	echo $(GIT_TAG)
ifeq ($(CONFIGURE_GIT),true)
	git config user.email "mail@makk.es"
	git config user.name "GitHub Actions Automation"
endif
	mkdir -p $(HELM_RELEASE_PACKAGE_DIR)
	echo $(GIT_TAG) >> $(HELM_RELEASE_PACKAGE_DIR)/index.yaml
	git fetch origin gh-pages
	git checkout -B gh-pages -t origin/gh-pages
	git reset --hard origin/gh-pages
	mkdir -p charts
	cp -r $(HELM_RELEASE_PACKAGE_DIR)/index.yaml charts/
	git add charts/
	git commit -m 'release: Updated helm repo for $(GIT_TAG)' -n
	git push origin gh-pages
	git checkout $(GIT_CURRENT_BRANCH)
