# Variables necessary to publish nablab update site on github pages to compile Monilog4Nablab
LAST=0.6.0
UPDATE_SITE_TAG=202211221454
UPDATE_SITE=fr.cea.nabla.updatesite-${LAST}.${UPDATE_SITE_TAG}.zip
# end of necessary variables

venv: ## create a local python virtual environement with required packages
	python3 -m venv .venv
	.venv/bin/python -m pip install --upgrade pip
	.venv/bin/python -m pip install mkdocs mkdocs-material mkdocs-macros-plugin

serve: ## compile the docs watching for change
	.venv/bin/mkdocs serve

build: ## build the documentation public website
	.venv/bin/mkdocs build --clean

deploy: ## build, commit to the gh-pages branch and push to GitHub
	# download update site and put it in the waited directory for Monilog4NabLab
	mkdir -p docs/update-site/${LAST}
	wget https://github.com/cea-hpc/NabLab/releases/download/v${LAST}/${UPDATE_SITE}
	unzip ${UPDATE_SITE} -d docs/update-site/${LAST}
	rm ${UPDATE_SITE}
	# publish doc
	.venv/bin/mkdocs gh-deploy
	# rm previously created directory
	rm -rf docs/update-site

