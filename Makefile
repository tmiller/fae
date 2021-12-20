.PHONY: run setup select override
.DEFAULT_GOAL := run

AG      := ansible-galaxy
AGFLAGS := role install --role-file requirements.yml

AP          := ansible-playbook
APVARS      := $(foreach file, $(wildcard variables/*.yml),--extra-vars @$(file))
APOVERRIDES := $(foreach file, $(wildcard overrides/*.yml),--extra-vars @$(file))
APFLAGS     := $(APVARS) $(APOVERRIDES)

TAGS = $(t)


setup:
	$(AG) $(AGFLAGS)

run: setup
	$(AP) $(APFLAGS) playbook.yml

select:
	$(AP) $(APFLAGS) --tags=$(TAGS) playbook.yml

override:
	cp variables/$(file).yml overrides/$(file).yml
