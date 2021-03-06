# Go パラメータ
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GORUN=$(GOCMD) run
GO_ENTRY_POINT_GATEWAY=cmd/gateway/main.go
BINARY_NAME=gateway.out
COVERAGE_FILE=cover.out
COVERAGE_FILE_HTML=cover.html
level=warn
env=development
caller= 
managerHost=localhost
managerPort=1883
gatewayHost=localhost
gatewayPort=1884

# Windows, WSL を想定
HTML_OPEN_CMD=explorer.exe
ifeq ($(shell uname),Darwin)
	# MacOS を想定
	HTML_OPEN_CMD=open -a "Safari"
endif

all: test build
.PHONY: build  # 擬似ターゲット
build:
	$(GOBUILD) -o $(BINARY_NAME) $(GO_ENTRY_POINT_GATEWAY)
.PHONY: test  # 擬似ターゲット
test:
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
coverage:
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
	go tool cover -html=$(COVERAGE_FILE) -o $(COVERAGE_FILE_HTML)
	$(HTML_OPEN_CMD) $(COVERAGE_FILE_HTML)
clean:
	$(GOCLEAN) ./...
	rm -f $(BINARY_NAME)
	rm -f $(COVERAGE_FILE) $(COVERAGE_FILE_HTML)
run:
	$(GORUN) cmd/gateway/main.go -level ${level} -env ${env} ${caller} -managerHost $(managerHost) -managerPort $(managerPort) -gatewayHost $(gatewayHost) -gatewayPort $(gatewayPort)