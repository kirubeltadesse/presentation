import os
import sys
from jinja2 import Environment, FileSystemLoader
import re


def generate_index(build_dir):
    env = Environment(loader=FileSystemLoader(searchpath="templates"))
    template = env.get_template('index_template.html')

    index_md_path = os.path.join("slides", "index.md")
    with open(index_md_path, 'r', encoding='utf-8') as f:
        index_md_content = f.read()

    files = []
    # Extract title and href from index_md_content
    pattern = r'\[([^\]]+)\]\(([^\)]+)\)'
    matches = re.findall(pattern, index_md_content)
    for match in matches:
        folder_path = match[1].lstrip('.').rstrip('/')
        title = match[0]
        href = f".{folder_path}{folder_path}.html"
        files.append({'href': href, 'title': title})

    rendered = template.render(index_md_content=index_md_content, files=files)

    with open(os.path.join(build_dir, 'index.html'), 'w', encoding='utf-8') as f:
        f.write(rendered)


if __name__ == "__main__":
    build_dir = sys.argv[1]
    generate_index(build_dir)
