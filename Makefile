.PHONY: run setup

AG      = ansible-galaxy
AGFLAGS = role install --force --role-file requirements.yml

AP          = ansible-playbook
APFLAGS     = -i localhost
APVARS      = $(foreach file, $(wildcard variables/*.yml),--extra-vars @$(file))
APOVERRIDES = $(foreach file, $(wildcard overrides/*.yml),--extra-vars @$(file))

TAGS = $(t)

run: setup
	$(AP) $(APFLAGS) $(APVARS) $(APOVERRIDES) playbook.yml

select:
	$(AP) $(APFLAGS) $(APVARS) $(APOVERRIDES) --tags=$(TAGS) playbook.yml

setup:
	$(AG) $(AGFLAGS)
