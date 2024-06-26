# Description: Makefile for converting Markdown slides to Reveal.js format
.PHONY: build serve clean check_build_dir index

# Default folder for slides
FOLDER ?= ./slides
# Remove trailing slash if present
FOLDER := $(patsubst %/,%,$(FOLDER))
REPO_ROOT := $(shell pwd)
BUILD_DIR = build/$(FOLDER)
PORT ?= 8000

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)/img/

# Rule to copy JS files
copy-js:
	cp $(REPO_ROOT)/sketch.js $(BUILD_DIR)/sketch.js
	cp $(REPO_ROOT)/dazzleSketch.js $(BUILD_DIR)/dazzleSketch.js

# Build will create img directory and copy-js
build: check_build_dir copy-js $(BUILD_DIR)/$(notdir $(FOLDER)).html index

# Convert Markdown slides to Reveal.js format
$(BUILD_DIR)/$(notdir $(FOLDER)).html: $(FOLDER)/config.yml | check_build_dir
	# Copy images to build directory if they exist
	if [ -d $(FOLDER)/img ]; then cp $(FOLDER)/img/* $(BUILD_DIR)/img/; fi
	pandoc -t revealjs -s $(shell grep -v '^-' $(FOLDER)/config.yml | xargs -I{} echo $(FOLDER)/{}) \
		--template=$(REPO_ROOT)/template.html --resource-path=$(FOLDER) --slide-level=2 -o $@
	@echo "Generated $(notdir $(FOLDER)).html: build/$(notdir $(FOLDER)).html"

# Generate index.html with links to all slides
index: check_build_dir
	python3 $(REPO_ROOT)/py_scripts/generate_index.py $(REPO_ROOT)/build
	@echo "Generated index: build/index.html"


clean:
	rm -rf build
	@echo "Removed build directory"

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server $(PORT) --directory build
	@echo "Serving slides at http://localhost:$(PORT)"

