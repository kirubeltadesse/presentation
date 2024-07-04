import os
import sys
from jinja2 import Environment, FileSystemLoader

def generate_index(build_dir):
    env = Environment(loader=FileSystemLoader(searchpath="templates"))
    template = env.get_template('index_template.html')

    files = []
    for root, dirs, filenames in os.walk(build_dir):
        for filename in filenames:
            if filename.endswith('.html') and filename != 'index.html':
                href = os.path.join(root, filename).replace(build_dir + os.sep, '')
                title = os.path.basename(filename).replace('.html', '')
                files.append({'href': href, 'title': title})

    rendered = template.render(files=files)

    with open(os.path.join(build_dir, 'index.html'), 'w') as f:
        f.write(rendered)

if __name__ == "__main__":
    build_dir = sys.argv[1]
    generate_index(build_dir)

