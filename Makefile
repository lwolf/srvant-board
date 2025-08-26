
# Makefile for srvant-board

# Default job to run
JOB ?= on_commit

# Check for dependencies
.PHONY: check_deps
check_deps:
	@command -v docker >/dev/null 2>&1 || { echo >&2 "Error: docker is not installed. Please install docker to continue."; exit 1; }
	@command -v act >/dev/null 2>&1 || { echo >&2 "Error: act is not installed. Please install act to continue."; exit 1; }

# Run act for a specific job
# Usage: make act [JOB=job_name]
.PHONY: act
act: check_deps
	@mkdir -p .artifacts
	act -j $(JOB) --artifact-server-path .artifacts -W .github/workflows/kibot-quick.yml


# Run the 3D workflow
.PHONY: act-3d
act-3d:
	@mkdir -p .artifacts
	act -j on_commit --artifact-server-path .artifacts -W .github/workflows/kibot-3d.yml

# Run the diff workflow with specific commits
.PHONY: act-diff
act-diff:
	@if [ -z "$(OLD_COMMIT)" ] || [ -z "$(NEW_COMMIT)" ]; then \
		echo "Error: OLD_COMMIT and NEW_COMMIT must be set."; \
		exit 1; \
	fi
	@mkdir -p .artifacts
	@sed -i "s/old: .*/old: $(OLD_COMMIT)/" kibot-quick.yaml
	@sed -i "s/new: .*/new: $(NEW_COMMIT)/" kibot-quick.yaml
	act -j on_commit --artifact-server-path .artifacts -W .github/workflows/kibot-quick.yml
	@git checkout kibot-quick.yaml

# Run the release workflow
.PHONY: act-release
act-release:
	@mkdir -p .artifacts
	act -j release --artifact-server-path .artifacts -W .github/workflows/kibot-full.yml

# Clean up artifacts
.PHONY: clean
clean:
	@echo "Cleaning up artifacts..."
	@rm -rf .artifacts

# Help message
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  act [JOB=job_name]  - Run a specific GitHub Actions job (default: on_commit)."
	@echo "  act-3d              - Run the 3D and STEP generation workflow."
	@echo "  act-diff OLD_COMMIT=<hash> NEW_COMMIT=<hash> - Run the diff workflow between two commits."
	@echo "  act-release         - Run the release workflow."
	@echo "  clean               - Remove the .artifacts directory."
	@echo "  check_deps          - Check for required dependencies (docker, act)."
	@echo "  help                - Show this help message."


