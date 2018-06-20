DIST_DIRS       = find * -maxdepth 0 -type d -exec

# go option
GO        ?= go
TAGS      := kqueue
TESTFLAGS :=
LDFLAGS   :=
GOFLAGS   :=
BINDIR    := $(CURDIR)/bin

# Required for globs to work correctly
SHELL=/bin/bash

.PHONY: all
all: test

.PHONY: test
test: TESTFLAGS += -race -v
test: test-lint test-cover

test-cover:
	script/cover.sh

.PHONY: test-lint
test-lint:
	script/lint.sh

HAS_GOMETALINTER := $(shell command -v gometalinter;)
HAS_DEP := $(shell command -v dep;)
HAS_GOX := $(shell command -v gox;)
HAS_GIT := $(shell command -v git;)

.PHONY: bootstrap
bootstrap:
ifndef HAS_GOMETALINTER
	go get -u github.com/alecthomas/gometalinter
	gometalinter --install
endif
ifndef HAS_DEP
	go get -u github.com/golang/dep/cmd/dep
endif
ifndef HAS_GOX
	go get -u github.com/mitchellh/gox
endif
ifndef HAS_GIT
	$(error You must install git)
endif
	dep ensure
