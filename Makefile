OS = darwin freebsd linux openbsd
ARCHS = 386 arm amd64 arm64

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

all: build release release-windows

build: ## Build the project
	CGO_ENABLED=0 go build

release: clean ## Generate releases for unix systems
	@for arch in $(ARCHS);\
	do \
		for os in $(OS);\
		do \
			echo "Building $$os-$$arch"; \
			mkdir -p build/webhook-$$os-$$arch/; \
			GOOS=$$os GOARCH=$$arch go build -o build/webhook-$$os-$$arch/webhook; \
			tar cz -C build -f build/webhook-$$os-$$arch.tar.gz webhook-$$os-$$arch; \
		done \
	done

release-windows: clean ## Generate release for windows
	@for arch in $(ARCHS);\
	do \
		echo "Building windows-$$arch"; \
		mkdir -p build/webhook-windows-$$arch/; \
		GOOS=windows GOARCH=$$arch go build -o build/webhook-windows-$$arch/webhook.exe; \
		tar cz -C build -f build/webhook-windows-$$arch.tar.gz webhook-windows-$$arch; \
	done

test: ## Execute tests
	go test -v ./...

clean: ## Remove building artifacts
	rm -rf build
	rm -f webhook
