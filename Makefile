.PHONY: build serve check_build_dir

FOLDER=./slides
FOLDER_NAME=$(shell basename $(FOLDER))
BUILD_DIR = build/$(FOLDER_NAME)

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)/img/


# Default build
build: check_build_dir $(BUILD_DIR)/slides.html index

# Convert Markdown slides to Reveal.js format
$(BUILD_DIR)/slides.html: $(FOLDER)/config.yml | check_build_dir
	cp $(FOLDER)/img/* $(BUILD_DIR)/img/
	pandoc -t revealjs -s $(shell grep -v '^-' $(FOLDER)/config.yml | xargs -I{} echo $(FOLDER)/{}) --resource-path=$(FOLDER) -V revealjs-url=https://unpkg.com/reveal.js@4.2.0/ -V slideNumber=true -o $@
	echo "Generated index: build/index.html"

# Generate index.html with links to all files in the build directory
index: check_build_dir
	echo "<html><body><h1>Presentation Files</h1><ul>" > build/index.html
	find build -type f -name '*.html' | grep -v 'index.html' | while read file; do \
		title=$$(basename "$$file" .html); \
		href=$$(echo $$file | sed 's|^build/||'); \
		echo "<li><a href=\"$$href\">$$title</a></li>"; \
	done >> build/index.html
	echo "</ul></body></html>" >> build/index.html
	echo "Generated index: build/index.html"

clean:
	rm -rf build

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server 8000 --directory build

