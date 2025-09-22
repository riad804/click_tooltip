.PHONY: push publish deleteTag

push:
	@if [ -z "$(msg)" ]; then \
		echo "Usage: make push msg='your commit message'"; exit 1; \
	fi
	git add .
	git commit -m "$(msg)"
	git push origin main

publish:
	@if [ -z "$(v)" ]; then \
		echo "Usage: make publish v=1.0.0"; exit 1; \
	fi
	git tag v$(v)
	git push origin v$(v)

deleteTag:
	@if [ -z "$(v)" ]; then \
		echo "Usage: make deleteTag v=1.0.0"; exit 1; \
	fi
	git tag -d v$(v)
	git push origin :refs/tags/v$(v)
