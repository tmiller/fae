########################################################################
# To create comma separated lists
########################################################################

null                :=
space               := $(null) #
comma               := ,

########################################################################
# User defined functions
########################################################################

should_become = $(filter $(1),$(ROLE_BECOME_LIST))
become        = $(or $(call should_become,$@), $(call should_become,$(r)))

find_vars     = $(foreach file, $(wildcard $(1)/*.yml),--extra-vars @$(file))

remove_if			= $(if $(1),$(filter-out $(1),$(2)),)
remove_action = $(call remove_if,$(1),$(ACTION_TAGS))
remove_role   = $(call remove_if,$(1),$(ROLE_TAGS))

########################################################################
# Binaries and options
########################################################################

SYS_PYTHON          := /usr/bin/python3
SYS_PIP             := /usr/bin/pip3

VENV                := .ansible
VENV_BIN            := $(VENV)/bin
VENV_BINS            = $(AG) $(AP) $(VENV_PIP)
VENV_PIP            := $(VENV_BIN)/pip
VENV_PY_DEPS        := ansible

AG                  := $(VENV_BIN)/ansible-galaxy
AG_FLAGS            := role install --role-file requirements.yml

AP                  := $(VENV_BIN)/ansible-playbook
AP_VARS             := $(call find_vars,variables)
AP_OVERRIDES        := $(call find_vars,overrides)
AP_BECOME            = $(if $(become),--ask-become-pass,)
AP_FLAGS             = $(strip $(AP_BECOME) $(strip $(AP_VARS) $(AP_OVERRIDES)))

ROLE_BECOME_LIST    := all op

ROLE_TAGS           := $(filter-out tags:,$(shell grep 'tags:' playbook.yml))
ACTION_TAGS         := install config update
ACTION_SKIP_TAGS     = $(strip $(call remove_action,$@) $(call remove_role,$(r)))

AP_SKIP_TAGS         = --skip-tags $(subst $(space),$(comma),$(ACTION_SKIP_TAGS))
AP_TAGS              = --tags $(subst $(space),$(comma),$(strip $(@) $(r)))

########################################################################
# Rule definitions
########################################################################

.DEFAULT_GOAL := all

.PHONY: all
all: galaxy | $(VENV_BINS)	## Run main playbook
	$(AP) $(AP_FLAGS) --ask-become-pass playbook.yml

.PHONY: galaxy							## Install galaxy requirements
galaxy: | $(VENV_BINS)
	$(AG) $(AG_FLAGS)

.PHONY: $(ACTION_TAGS)			## make ACTION [r=ROLE]
$(ACTION_TAGS): $(VENV_BINS)
	$(AP) $(AP_FLAGS) $(AP_TAGS) $(AP_SKIP_TAGS) playbook.yml

.PHONY: $(ROLE_TAGS)				## make ROLE
$(ROLE_TAGS): $(VENV_BINS)
	$(AP) $(AP_FLAGS) $(AP_TAGS) playbook.yml

.PHONY: roles
roles:											## list roles
	@printf "%s\n" $(ROLE_TAGS) | sort

.PHONY: actions
actions:										## list roles
	@printf "%s\n" $(ACTION_TAGS) | sort

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
