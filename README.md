# presentation

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/kirubeltadesse/presentation/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/kirubeltadesse/presentation/tree/master)

Create slides using Markdown, pandoc, and revealJS.

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

### You can manually push the build

Build locally and push mv the contents of the build folder outside the build folder.

```bash
make build FOLDER=preo
```

2. Push directly to the gh-pages repo

### Automatically CircleCI will handle the build

1. Push the master repo and Circle ci will handle the deployment.