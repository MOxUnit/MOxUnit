install:
	pip install requirements

serve:
	mkdocs serve -a localhost:8080

package.json:
	npm install `cat npm-requirements.txt`

# Linting

remark: package.json
	npx remark \
		./docs \
		--frail \
		--rc-path .remarkrc
