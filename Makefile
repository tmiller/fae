.DEFAULT_GOAL := play

SYS_PYTHON    := /usr/bin/python3
SYS_PIP       := /usr/bin/pip3

VENV          := .ansible
VENV_BIN      := $(VENV)/bin
VENV_PIP      := $(VENV_BIN)/pip
VENV_PY_DEPS  := ansible

AG            := $(VENV_BIN)/ansible-galaxy
AG_FLAGS      := role install --role-file requirements.yml

AP            := $(VENV_BIN)/ansible-playbook
AP_VARS       := $(foreach file, $(wildcard variables/*.yml),--extra-vars @$(file))
AP_OVERRIDES  := $(foreach file, $(wildcard overrides/*.yml),--extra-vars @$(file))
AP_FLAGS      := $(AP_VARS) $(AP_OVERRIDES)
AP_TAGS       := --tags $(t)

VENV_BINS     := $(AG) $(AP) $(VENV_PIP)

.PHONY: help
help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

.PHONY: galaxy
galaxy: | $(VENV_BINS)
	$(AG) $(AG_FLAGS)

.PHONY: play
play: galaxy | $(VENV_BINS) ## Run main playbook
	$(AP) $(AP_FLAGS) playbook.yml

.PHONY: tags
tags: | $(VENV_BINS)        ## t=[TAG] Run only tags
	$(AP) $(AP_FLAGS) $(AP_TAGS) playbook.yml

$(VENV_BINS):
	$(SYS_PIP) install --user virtualenv
	$(SYS_PYTHON) -m virtualenv $(VENV)
	$(VENV_PIP) install $(VENV_PY_DEPS)

.PHONY: override
override:                   ## file=[file] Override files
	cp variables/$(file).yml overrides/$(file).yml

.PHONY: clean
clean:
	rm -rf $(VENV)
