#TODO: use a smaller and latest image
FROM ubuntu:latest

# Install pandoc
RUN apt-get update && apt-get install -y \
    wget \
    make \
    && rm -rf /var/lib/apt/lists/*

# install latest pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-1-amd64.deb

RUN dpkg -i pandoc-2.9.2.1-1-amd64.deb

# install revealjs
RUN wget https://github.com/hakimel/reveal.js/archive/master.tar.gz

RUN tar -xzvf master.tar.gz

RUN mv reveal.js-master reveal.js

WORKDIR /reveal.js/content

ENTRYPOINT [ "tail", "-f", "/dev/null" ]

