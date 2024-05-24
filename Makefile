.PHONY: build serve check_build_dir

FOLDER=./slides
FOLDER_NAME=$(shell basename $(FOLDER))
BUILD_DIR = build/$(FOLDER_NAME)

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)/img/


# Default build
build: check_build_dir $(BUILD_DIR)/slides.html

# Convert Markdown slides to Reveal.js format
$(BUILD_DIR)/slides.html: $(FOLDER)/config.yml | check_build_dir
	cp $(FOLDER)/img/* $(BUILD_DIR)/img/
	pandoc -t revealjs -s $(shell grep -v '^-' $(FOLDER)/config.yml | xargs -I{} echo $(FOLDER)/{}) --resource-path=$(FOLDER) -V revealjs-url=https://unpkg.com/reveal.js@4.2.0/ -V slideNumber=true -o $@

clean:
	rm -rf build

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server 8000 --directory $(BUILD_DIR)
