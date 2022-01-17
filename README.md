# fae

This project sets up a computer for development

## Supported Operating Systems

- macOS

## Dependencies

- make
- grep
- cut
- system Python3
- system pip3

## Organization

A Makefile is used to perform the installation. The playbook will reference
either local roles or third party roles from ansible galaxy. Variables safe to
be checked in to git will be placed in the `variables` subdirectory with the
name of the role they are used to configure. The `overrides` subdirectory is an
additional set of variables insecure to check into git or used to override
settings in the `variables` that might differ between machines.


## What happens

This will try to find the system python and install virtualenv using pip. Then
it will create a virtualenv named `.ansible` in this directory. It will then
install ansible and its dependencies to that virtualenv. After that it will
install any ansible galaxy roles in the `requirements.yml` file. Finally it
will attempt to run the playbook against this local machine.


## Running

```shell

# Setup computer
make

# Show available roles
make roles

# Show available roles
make actions

# Run entire role
make ROLE

# Run action across all roles
make ACTION

# Run action on single role
make ACTION r=ROLE

# Install ansible galaxy roles and collections
make galaxy

# Copy a vars file for overrides
make override file=git

# Remove the virtualenv
make clean
```


## Override Variables

`neovim_fugitive_gitlab_domains`: Array of strings to override the url used by
                                  the GBrowse command on gitlab projects.
