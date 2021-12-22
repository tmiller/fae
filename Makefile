.PHONY: play galaxy tags override clean
.DEFAULT_GOAL := play

SYS_PYTHON   := /usr/bin/python3
SYS_PIP      := /usr/bin/pip3

A_PIP        := ansible/bin/pip

AG           := ansible/bin/ansible-galaxy
AG_FLAGS     := role install --role-file requirements.yml

AP           := ansible/bin/ansible-playbook
AP_VARS      := $(foreach file, $(wildcard variables/*.yml),--extra-vars @$(file))
AP_OVERRIDES := $(foreach file, $(wildcard overrides/*.yml),--extra-vars @$(file))
AP_FLAGS     := $(AP_VARS) $(AP_OVERRIDES)
AP_TAGS      := --tags $(t)

BINS         := $(AG) $(AP) $(A_PIP)

galaxy: | $(BINS)
	$(AG) $(AG_FLAGS)

play: galaxy | $(BINS)
	$(AP) $(AP_FLAGS) playbook.yml

tags: | $(BINS)
	$(AP) $(AP_FLAGS) $(AP_TAGS) playbook.yml

$(BINS):
	$(SYS_PIP) install --user virtualenv
	$(SYS_PYTHON) -m virtualenv ansible
	$(A_PIP) install ansible

override:
	cp variables/$(file).yml overrides/$(file).yml

clean:
	rm -rf ansible
