# Go パラメータ
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GORUN=$(GOCMD) run
GO_ENTRY_POINT_GATEWAY=cmd/gateway/main.go
BINARY_DEFAULT_NAME=gateway
BINARY_DEFAULT_SUFFIX=out
BINARY_LINUX_NAME=gateway-linux
COVERAGE_FILE=cover.out
COVERAGE_FILE_HTML=cover.html
DOCKER_COMPOSE=docker-compose
TEST_DOCKER_COMPOSE_FILE=./build/docker-compose.yml
TEST_DOCKER_COMPOSE_UP_D=$(DOCKER_COMPOSE) -f $(TEST_DOCKER_COMPOSE_FILE) up -d
TEST_DOCKER_COMPOSE_DOWN=$(DOCKER_COMPOSE) -f $(TEST_DOCKER_COMPOSE_FILE) down
level=info
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
build: clean
	./build.sh

.PHONY: test  # 擬似ターゲット
test:
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
coverage:
	$(GOTEST) -coverprofile=$(COVERAGE_FILE) ./...
	go tool cover -html=$(COVERAGE_FILE) -o $(COVERAGE_FILE_HTML)
	$(HTML_OPEN_CMD) $(COVERAGE_FILE_HTML)
clean:
	$(GOCLEAN) ./...
	rm -f *.$(BINARY_DEFAULT_SUFFIX)
	rm -f *.arm64
	rm -f *.arm
	rm -f $(COVERAGE_FILE) $(COVERAGE_FILE_HTML)
broker-up:
	$(TEST_DOCKER_COMPOSE_UP_D)
broker-down:
	$(TEST_DOCKER_COMPOSE_DOWN)
run: broker-down broker-up
	$(GORUN) cmd/gateway/main.go -level ${level} -env ${env} ${caller} -managerHost $(managerHost) -managerPort $(managerPort) -gatewayHost $(gatewayHost) -gatewayPort $(gatewayPort)
