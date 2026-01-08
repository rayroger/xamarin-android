.PHONY: help build test run clean install-deps all

# Default target
help:
	@echo "SimpleApp - Xamarin Android with Espresso Tests"
	@echo ""
	@echo "Available targets:"
	@echo "  make build          - Build the Xamarin app"
	@echo "  make test           - Build and run Espresso tests (requires emulator/device)"
	@echo "  make run            - Build and run the app on device/emulator"
	@echo "  make all            - Build app, start emulator, and run all tests"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make install-deps   - Install required dependencies"
	@echo ""
	@echo "Quick start:"
	@echo "  make all            - Complete build and test pipeline"

# Install dependencies
install-deps:
	@echo "Installing .NET Android workload..."
	dotnet workload install android --skip-manifest-update

# Build the Xamarin app
build:
	@echo "Building Xamarin app..."
	./build-app.sh

# Run tests (requires emulator/device)
test:
	@echo "Running Espresso tests..."
	./build-tests.sh
	./run-tests.sh

# Run the app
run: build
	@echo "Running app on device/emulator..."
	./run-app.sh

# Complete build and test pipeline
all:
	@echo "Running complete build and test pipeline..."
	./build-and-test.sh

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	cd SimpleApp && dotnet clean
	cd EspressoTests && (./gradlew clean 2>/dev/null || gradle clean 2>/dev/null || echo "Gradle not configured yet")
	@echo "Clean complete"
