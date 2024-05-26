# presentation
creating slides revealjs 


[![Build Status](https://app.travis-ci.com/kirubeltadesse/presentation.svg?branch=master)](https://app.travis-ci.com/kirubeltadesse/presentation)

[Here](https://github.com/jgm/pandoc/wiki/Using-pandoc-to-produce-reveal.js-slides) is the setup for the `Dockerfile` used to create the slides.

1. First, use `d` run presentation bash`
2. run the command for the link above
3. you can view the slide by manually clicking on the `.html` file

[Here](https://gist.github.com/jonashackt/85f9df62986db4e70396e3c494e26b76) is the template used to create the slide for the presentation.

Speaker notes

::: notes

content for the speaker

:::

I am not sure how this travel can be triggered. This should work!

## Deployment

### First option

1. build locally and push mv the contents of the build folder outside the build folder.

```bash
make build FOLDER=preo
```

2. push directly to the gh-pages repo

### second option

1. push the master repo and Circle ci will handle the deployment (not reliable so far)