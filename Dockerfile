#TODO: use a smaller and latest image
FROM ubuntu:latest

# Install pandoc
RUN apt-get update && apt-get install -y \
    pandoc \
    wget \
    && rm -rf /var/lib/apt/lists/*

# install revealjs
RUN wget https://github.com/hakimel/reveal.js/archive/master.tar.gz

RUN tar -xzvf master.tar.gz

RUN mv reveal.js-master reveal.js

WORKDIR /reveal.js/content

