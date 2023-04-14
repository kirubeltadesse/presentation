import os, shutil
import feedparser
from jinja2 import Template, Environment, FileSystemLoader


URLS = (
    'https://feeds.arstechica.com/arstechnica/index/',
    'https://www.reddit.com/r/programming/.rss',
    'https://www.theatlantic.com/feed/all/',
    'https://css-tricks.com/feed/',
    'https://www.theverge.com/rss/index.xml',
    'https://lobste.rs/rss'
)

class SiteGenerator(object):

    def __init__(self):
        self.feeds = []
        self.env = Environment(loader = FileSystemLoader('template'))
        self.fetch_feeds()
        self.empty_public()
        self.copy_static()
        self.render_page()

    def fetch_feeds(self):
        """ Request and parse all of the feeds, saving thme in self.feeds """
        for url in URLS:
            print("Fetching {}".format(url))
            self.feeds.append(feedparser.parse(url))

    def empty_public(self):
        """ Ensure the public directory is empty before generating. """

        try: 
            shutil.rmtree('./public')
            os.mkdir('./public')

        except:

            print("Error cleaning up old files.")
        
    def copy_static(self):
        """ Copy static assets to the public directory """
        try:
            shutil.copytree('template/static', 'public/static')
        except:
            print("Error copying static files.")

    # FIXME: render() missing 1 required positional argument: 'self' 
    def render_page(self):
        print("Rendering page to static file.")
        template = self.env.get_template('index.html')
        with open('public/index.html', 'w+') as file:
            html = template.render(
                title = "Spiffy Feeds",
                feeds =self.feeds
            )
            file.write(html)

 
if __name__ == "__main__":
    SiteGenerator()
