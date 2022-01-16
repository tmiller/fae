########################################################################
# To create comma separated lists
########################################################################

null                :=
space               := $(null) #
comma               := ,

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
AP_VARS             := $(foreach file, $(wildcard variables/*.yml),--extra-vars @$(file))
AP_OVERRIDES        := $(foreach file, $(wildcard overrides/*.yml),--extra-vars @$(file))
AP_FLAGS            := $(strip $(AP_VARS) $(AP_OVERRIDES))

ROLE_TAGS           := $(filter-out tags:,$(shell grep 'tags:' playbook.yml))
ACTION_TAGS         := install config update

ifdef r
	AP_SKIP_TAGS_TAGS  = $(filter-out $@,$(ACTION_TAGS) $(filter-out $(r),$(ROLE_TAGS)))
else
	AP_SKIP_TAGS_TAGS  = $(filter-out $@,$(ACTION_TAGS))
endif

AP_SKIP_TAGS         = --skip-tags $(subst $(space),$(comma),$(AP_SKIP_TAGS_TAGS))
AP_TAGS              = --tags $(subst $(space),$(comma),$(strip $(@) $(r)))


.DEFAULT_GOAL := all

.PHONY: all
all: galaxy | $(VENV_BINS) ## Run main playbook
	$(AP) $(AP_FLAGS) playbook.yml

.PHONY: galaxy
galaxy: | $(VENV_BINS)
	$(AG) $(AG_FLAGS)

.PHONY: $(ACTION_TAGS)			## (install | config | update) [r=role]
$(ACTION_TAGS): $(VENV_BINS)
	$(AP) $(AP_FLAGS) $(AP_TAGS) $(AP_SKIP_TAGS) playbook.yml

.PHONY: $(ROLE_TAGS)				## (role tag) [r=role]
$(ROLE_TAGS): $(VENV_BINS)
	$(AP) $(AP_FLAGS) $(AP_TAGS) playbook.yml

.PHONY: roles
roles:
	@printf "%s\n" $(ROLE_TAGS) | sort

.PHONY: actions
actions:
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
