SHELL := /bin/bash

.PHONY: all provision register reset factory install

all: help

help:
	@echo "Targets:"
	@echo "  install    - mark scripts executable"
	@echo "  provision  - full guided provisioning (prompts)"
	@echo "  register   - register this key with your computer"
	@echo "  reset      - reset FIDO2 application (ERASES credentials)"
	@echo "  factory    - batch provision many keys (with optional integration hook)"

install:
	chmod +x bin/nadoo-key || true
	chmod +x scripts/linux/*.sh || true
	chmod +x scripts/macos/*.sh || true
	chmod +x scripts/integrations/*.sh || true

provision: install
	sudo ./bin/nadoo-key provision

register: install
	sudo ./bin/nadoo-key register

reset: install
	sudo ./bin/nadoo-key reset

factory: install
	sudo ./bin/nadoo-key factory
