AGENTS=api scheduler aggregator worker
BUILD_DIR=build

CC=go build
GIT_HASH=$(shell git rev-parse HEAD)
DFLAGS=-race
CFLAGS=-ldflags "-X main.gitHash=$(GIT_HASH)"
CROSS=GOOS=linux GOARCH=amd64

VPATH= $(BUILD_DIR)

.SECONDEXPANSION:

.PHONY: build
build:
	go build $(DFLAGS) $(CFLAGS) -o $(BUILD_DIR)/haproxy-exporter ./cmd/haproxy-exporter

build-all: build-linux-amd64 build-darwin-amd64 build-windows-amd64

build-linux-amd64:
	GOOS=linux GOARCH=amd64 make build-target

build-haproxy-stat-linux-amd64:
	GOOS=linux GOARCH=amd64 make build-haproxy-stat-target

build-darwin-amd64:
	GOOS=darwin GOARCH=amd64 make build-target

build-windows-amd64:
	GOOS=windows GOARCH=amd64 BIN_EXT=.exe make build-target

build-target:
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) $(CC) $(CFLAGS) \
	-o $(BUILD_DIR)/haproxy-exporter_$(GOOS)-$(GOARCH)$(BIN_EXT) ./cmd/haproxy-exporter

build-haproxy-stat-target:
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) $(CC) $(CFLAGS) \
	-o $(BUILD_DIR)/haproxy-stat_$(GOOS)-$(GOARCH)$(BIN_EXT) ./cmd/haproxy-stat

.PHONY: release
release:
	$(CC) $(CFLAGS) -o $(BUILD_DIR)/haproxy-exporter haproxy-exporter.go

.PHONY: lint
lint:
	@command -v gometalinter >/dev/null 2>&1 || { echo >&2 "gometalinter is required but not available please follow instructions from https://github.com/alecthomas/gometalinter"; exit 1; }
	gometalinter --deadline=180s --disable-all --enable=gofmt ./cmd/... ./core/... ./
	gometalinter --deadline=180s --disable-all --enable=vet ./cmd/... ./core/... ./
	gometalinter --deadline=180s --disable-all --enable=golint ./cmd/... ./core/... ./
	gometalinter --deadline=180s --disable-all --enable=ineffassign ./cmd/... ./core/... ./
	gometalinter --deadline=180s --disable-all --enable=misspell ./cmd/... ./core/... ./
	gometalinter --deadline=180s --disable-all --enable=staticcheck ./cmd/... ./core/... ./

.PHONY: format
format:
	gofmt -w -s ./cmd ./core haproxy-exporter.go

.PHONY: dev
dev: format lint build

.PHONY: clean
clean:
	-rm -r build
