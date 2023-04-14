"""
Reads congifuration in YAML format and generates the Markdown.
"""
import json
import os
import sys
from typing import Any, Dict, NoReturn


import jinja2
import yaml

__all__ = ["json", "sys", "os"]

def main() -> NoReturn:
    """The main function."""
    config_file = "./config.yaml"

    try:
        config = read_config(config_file=config_file)
        config = process_config(config)
        create_markdown(config)
        generate_makefile(config)
    except Exception as error:
        error(str(error))


# TODO: Enable-list. Activates enhanced reveal.js functionality 
ENABLE = {"math", "notes", "search"}


# TODO: Extract the configuration from the YAML file.
def read_config(config_file: str) -> Dict[str, Any]:
    """Reads the configuration from the YAML file."""
    with open(config_file, encoding="UTF-8") as file:
        config = yaml.safe_load(file.read())
        
    if not ininstance(config, dict):
        raise ValueError("Invalid configuration file. It must be a dictionary.")

    return config


# process the configuration
def process_config(config: Dict[str, Any]) -> Dict[str, Any]:
    """Processes the configuration."""

    if("chapters" in config):

        config = {"index": config}


        # for chapter in config["chapters"]:
        #     if "slides" in chapter:
        #         for slide in chapter["slides"]:
        #             if "content" in slide:
        #                 slide["content"] = slide["content"].splitlines()
        #             else:
        #                 slide["content"] = []
        #     else:
        #         chapter["slides"] = []

    for variant in config.values():

        # remove the '.md' extension from the slides
        variant["chapters"] = [_[:-3] for _ in variant["chapters"]]

        # handle filetered slides in proper order
        filters = [
            "pandoc-link-to-source",
            "pandoc-code-with", 
            "pandoc-include-code",
            "pandoc-code-noqa",
            "pandoc-emphasze-code",
            "pandoc-fontawesome",
        ]

        filters_config = variant.get("filters", {})
        include = filters_config.get("include", [])
        exclude = filters_config.get("exclude", [])

        for filter in filters:
            if filter in exclude:
                variant["filters"].remove(filter)
            elif filter in include:
                variant["filters"].append(filter)

        # variant["filters"] = filters

        # We validate the enable list
        if "enable" in variant:

            variant["enable"] = {_.lower() for _ in variant["enable"]}

            if not variant["enable"].issubset(ENABLE):
                valid = ", ".join(sorted({"math", "notes", "search"}))
                raise ValueError("Invalid enable list. Valid options are: " + valid)

    return config



# Template for top-leve Makefile which is generated from the configuration sets up top-level targets for each variant.
# It also generates the Makefile for top-level images directory.

template = jinja2.Template(
    r"""
.DELETE_ON_ERROR:
.PHONY: all clean build
build: {% for variant in variants %} build/{{ variant }}.html{% endfor %}

build/%.html: build/__%/index.html | build/__%
    cp $< $@

build/imgs:
    mkdir -p $@

build/imgs/%: imgs/% | build/imgs
    cp $< $@

{% for variant in variants %}
build/__{{ variant }}:
    mkdir -p $@
-include build/__{{ variant }}/__config.d # FIXME: __config.d
{% endfor %}

"""
)


# render the template
def render_template(template: jinja2.Template, path: str, **kwargs: Any) -> None:
    """Renders the template."""

    output = template.render(**kwargs)

    if os.path.exists(path):
        with open(path, encoding="UTF-8") as file:
            if file.read() == output:
                return
    with open(path, "w", encoding="UTF-8") as file:
        file.write(output)

# create markdown files
def create_markdown(config: Dict[str, Any]) -> NoReturn:
    """Creates the Markdown files."""

    variants = config.keys()

    render_template(template, "build/__config.d/", variants=variants)

    for variant in varients:
        # create a varient directory if it does not exist
        if not os.path.exists("build/__{variant}"):
            os.makedirs("build/__{variant}")

        var_config = config[variant]

        chapters = var_config["chapters"]
        title = var_config["title"]
        filters = var_config["filters"]
        css = var_config.get("css", [])
        enable = var_config.get("enable", set())
        preprocessor = var_config.get("preprocessor")

        render_template(
            template,
            "build/__{variant}/__config.d",
            variant=variant,
            title=title,
            chapters=chapters,
            filters=filters,
            css=css,
            enable=enable,
            preprocessor=preprocessor,
        )

        # TODO: create a json jinja2 store 

def error(message: str) -> NoReturn:
    """Prints the error message and exits with error code 1."""
    print(message, file=sys.stderr)
    sys.exit(1)

def warning(message: str) -> None:
    """Prints the warning message."""
    print(message, file=sys.stderr)

































