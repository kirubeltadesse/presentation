.PHONY: build serve check_build_dir

FOLDER ?= ./slides
# Remove trailing slash if present
FOLDER := $(patsubst %/,%,$(FOLDER))

# Get the root of the repository to use as a base for the template file in CircleCI
REPO_ROOT := $(shell pwd)

BUILD_DIR = build/$(FOLDER)

# Check if the build directory exists, if not create it
check_build_dir:
	mkdir -p $(BUILD_DIR)/img/


# Default build
build: check_build_dir $(BUILD_DIR)/$(notdir $(FOLDER)).html index

# Convert Markdown slides to Reveal.js format
$(BUILD_DIR)/$(notdir $(FOLDER)).html: $(FOLDER)/config.yml | check_build_dir
	cp $(FOLDER)/img/* $(BUILD_DIR)/img/
	pandoc -t revealjs -s $(shell grep -v '^-' $(FOLDER)/config.yml | xargs -I{} echo $(FOLDER)/{}) \
	--template=$(REPO_ROOT)/template.html --resource-path=$(FOLDER) --slide-level=2 -o $@
	echo "Generated $(notdir $(FOLDER)).html: build/$(notdir $(FOLDER)).html"

index: check_build_dir
	cp index.html build/index.html
	find build -type f -name '*.html' | grep -v 'index.html' | while read file; do \
		title=$$(basename "$$file" .html); \
		href=$$(echo $$file | sed 's|^build/||'); \
		link="<li><section><h1>$$title</h1><p><a href=\"$$href\">View Slide</a></p></section></li>"; \
		sed -i '' -e "s|<!-- END_LINKS -->|$$link\n<!-- END_LINKS -->|" build/index.html; \
	done
	echo "Generated index: build/index.html"

clean:
	rm -rf build

# Serve the slides using Python's HTTP server
serve:
	python3 -m http.server 8000 --directory build

