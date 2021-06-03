# Template of a MkDocs documentation project

MkDocs being a python project, run `make venv` to initialize a local virtual environment with required python packages.

To run a development server with live reloading, run `make serve`. Then go to http://127.0.0.1:8000 and start working on your documentation !

To build the website, run `make build`. It will create a `site/` folder with the public version of the site.

To build the site, commit it to gh-pages branch and push it to GitHub, run `make deploy`. The site becomes available [here](https://cea-hpc.github.io/NabLab/)
