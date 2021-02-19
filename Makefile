SHELL := /bin/bash -euo pipefail

GITHUB_REPO ?= "makkes/ghactions-playground.git"
GITHUB_USER ?=
GITHUB_TOKEN ?=
GIT_TAG ?= $(shell git describe --tags --exact-match)

.PHONY: bump-version
bump-version:
ifndef GITHUB_USER
	$(error "Please set GITHUB_USER")
endif
ifndef GITHUB_TOKEN
	$(error "Please set GITHUB_TOKEN")
endif
ifeq (,$(GIT_TAG))
	$(error "Please set GIT_TAG")
endif
	echo $(GIT_TAG)
ifeq ($(CONFIGURE_GIT),true)
	git config user.email "mail@makk.es"
	git config user.name "GitHub Actions Automation"
endif
	git remote remove github || true
	git remote add github "https://$(GITHUB_USER):$(GITHUB_TOKEN)@github.com/$(GITHUB_REPO)"
	git pull github $(GIT_TAG) --ff-only
	echo $(GIT_TAG) > version
	git add version
	git commit -m "update version to $(GIT_TAG)"
	git push github HEAD:master
