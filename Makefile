# TODO: add filter to this make file and test a sample filter

html: 
	pandoc -t revealjs \
	-s -o myslides.html slide.md \
	-V revealjs-url=https://unpkg.com/reveal.js@3.9.2/

