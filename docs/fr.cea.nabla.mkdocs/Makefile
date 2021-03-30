
venv: ## create a local python virtual environement with required packages
	python3 -m venv .venv
	.venv/bin/python -m pip install --upgrade pip
	.venv/bin/python -m pip install mkdocs mkdocs-material mkdocs-macros-plugin

serve: ## compile the docs watching for change
	.venv/bin/mkdocs serve

build: ## build the documentation public website
	.venv/bin/mkdocs build --clean

deploy: ## build, commit to the gh-pages branch and push to GitHub
	.venv/bin/mkdocs gh-deploy
