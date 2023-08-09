OS = darwin freebsd linux openbsd
ARCHS = 386 arm amd64 arm64

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

all: build release

build: ## Build the project
	CGO_ENABLED=0 go build

test: ## Execute tests
	go test -v ./...

clean: ## Remove building artifacts
	rm -rf build
	rm -f webhook

.PHONY: release-local
release-local: ## Build and release all binaries locally
	GITHUB_TOKEN=123 goreleaser release --clean --snapshot

.PHONY: release
release: ## Build and release all binaries
	goreleaser release --clean