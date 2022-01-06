# fae

This project sets up a laptop for development

## Supported Operating Systems

- macOS


## Organization

A Makefile is used to perform the installation. The playbook will reference
either local roles or third party roles from ansible galaxy. Variables safe to
be checked in to git will be placed in the `variables` subdirectory with the
name of the role they are used to configure. The `overrides` subdirectory is an
additional set of variables insecure to check into git or used to override
settings in the `variables` that might differ between machines.


## What happens

This will try to find the system python and install virtualenv using pip. Then
it will create a virtualenv named ansible in this directory. It will then
install ansible and its dependencies to that virtualenv. After that it will
install any ansible galaxy roles in the `requirements.yml` file. Finally it
will attempt to run the playbook against this local machine.


## Running

```shell
make
```

### Extra Features

#### Run only certain tags
```shell
make tags t=git
```

#### Install ansible galaxy roles and collections
```shell
make galaxy
```

#### Copy a vars file for overrides
```shell
make override file=git
```

#### Remove the virtualenv
```shell
make clean
```


## Override Variables

`neovim_fugitive_gitlab_domains`: Array of strings to override the url used by
                                  the GBrowse command on gitlab projects.
