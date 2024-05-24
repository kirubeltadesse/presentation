.PHONY: build serve check_build_dir

BUILD_DIR = build

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)


# Default build
build: $(BUILD_DIR)/slides.html

# Convert Markdown slides to Reveal.js format
# $(BUILD_DIR)/slides.html: $(FOLDER)/config.yml $(FOLDER)/slides.md | $(BUILD_DIR)
    # pandoc -t revealjs $(shell cat $(FOLDER)/config.yml) -o $(BUILD_DIR)/slides.html

# Convert Markdown slides to Reveal.js format
slides.html: check_build_dir slides.md
	pandoc -t revealjs -s slides.md -o $(BUILD_DIR)/slides.html

clean:
	rm -rf $(BUILD_DIR)/

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server 8000 --directory $(BUILD_DIR)


html:
	pandoc -t revealjs \
	-s -o myslides.html slide.md \
	-V revealjs-url=https://unpkg.com/reveal.js@3.9.2/

