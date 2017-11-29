# fae

So our journey forks yet again.

## Organization

Most thing anyone will ever care about will be in the playbook.yml file. Most
of the roles are located [here](https://gitlab.com/faen).

## Ansible Galaxy

Install packages
```
ansible-galaxy install -r requirements.yml -p roles
```

Update packages
```
ansible-galaxy install -f -r requirements.yml -p roles
```

## Running

This will install ansible-galaxy roles then install and configure your local
laptop
```
ansible-galaxy install -r requirements.yml -p roles
asnible-playbook -i inv playbook.yml
```
