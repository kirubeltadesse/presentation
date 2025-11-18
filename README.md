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

## Footer

You can add a footer to your slides that will appear at the bottom of each slide. To enable the footer:

1. Create a `metadata.yml` file in your slides directory (e.g., `slides/example/metadata.yml`)
2. Add the following configuration:

```yaml
---
title: "Your Presentation Title"
footer-enabled: true
footer-title: "Your Footer Text | 2024"
---
```

### Footer Options

- `footer-enabled`: Set to `true` to enable the footer, or `false` to disable it (default: `false`)
- `footer-title`: The text to display in the footer (default: uses the presentation title)

### Example

```yaml
---
title: "Example Presentation"
footer-enabled: true
footer-title: "Example Presentation | 2024"
---
```

If no `metadata.yml` file exists, the footer will be disabled by default.

## Deployment

### You can manually push the build

Build locally and push mv the contents of the build folder outside the build folder.

```bash
make build PROJECT=example
```

2. Push directly to the gh-pages repo

### Automatically CircleCI will handle the build

1. Push the master repo and Circle ci will handle the deployment.
