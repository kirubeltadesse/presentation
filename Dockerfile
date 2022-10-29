FROM pandoc/core

RUN wget https://github.com/hakimel/reveal.js/archive/master.tar.gz 

RUN tar -xzvf master.tar.gz  

RUN mv reveal.js-master reveal.js

COPY . /data