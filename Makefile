# Description: Makefile for converting Markdown slides to Reveal.js format
.PHONY: build serve clean check_build_dir index

# Default folder for slides
PROJECT ?= exmaple
SLIDES_DIR = slides/$(PROJECT)
BUILD_DIR = build/$(PROJECT)
REPO_ROOT := $(shell pwd)
PORT ?= 8000

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)/img/

# Build will create img directory
build: check_build_dir $(BUILD_DIR)/$(notdir $(PROJECT)).html index

# Convert Markdown slides to Reveal.js format
$(BUILD_DIR)/$(notdir $(PROJECT)).html: $(SLIDES_DIR)/config.yml | check_build_dir
	# Copy images to build directory if they exist
	if [ -d $(SLIDES_DIR)/img ]; then cp $(SLIDES_DIR)/img/* $(BUILD_DIR)/img/; fi
	pandoc -t revealjs -s $(shell grep -v '^-' $(SLIDES_DIR)/config.yml | xargs -I{} echo $(SLIDES_DIR)/{}) \
		--template=$(REPO_ROOT)/template.html --resource-path=$(SLIDES_DIR) --slide-level=2 -o $@
	@echo "Generated $(PROJECT).html: in $(BUILD_DIR).html"

# Generate index.html with links to all slides
index: check_build_dir # FIXME: use an index.md file to generate the index.html
	python3 $(REPO_ROOT)/py_scripts/generate_index.py $(REPO_ROOT)/build
	@echo "Generated index: build/index.html"


clean:
	rm -rf build
	@echo "Removed build directory"

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server $(PORT) --directory build
	@echo "Serving slides at http://localhost:$(PORT)"

