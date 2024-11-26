
SRC_DIR := src
TEST_DIR := tests
TEST_HOST ?= localhost:5000


.PHONY: help lint lint-fix image push run deploy undeploy test test-report test-api clean .EXPORT_ALL_VARIABLES
.DEFAULT_GOAL := help


run: ## 🏃‍ Run locally using Dotnet CLI
	dotnet watch --project $(SRC_DIR)/dotnet-demoapp.csproj

test-report: ## 🎯 Unit tests with xUnit & output report
	rm -rf $(TEST_DIR)/TestResults
	dotnet test $(TEST_DIR)/tests.csproj --test-adapter-path:. --logger:junit --logger:html

test-api: .EXPORT_ALL_VARIABLES ##🚦 Run integration API tests, server must be running!
	cd tests \
	&& npm install newman \
	&& ./node_modules/.bin/newman run ./postman_collection.json --env-var apphost=$(TEST_HOST)

clean: ## 🧹 Clean up project
	rm -rf $(TEST_DIR)/node_modules
	rm -rf $(TEST_DIR)/package*
	rm -rf $(TEST_DIR)/TestResults
	rm -rf $(TEST_DIR)/bin
	rm -rf $(TEST_DIR)/obj
	rm -rf $(SRC_DIR)/bin
	rm -rf $(SRC_DIR)/obj
