# Ansible Docker images

Images for running [Ansible](https://www.ansible.com/) with [winpyrm](https://pypi.org/project/pywinrm/0.2.2/) installed. For instructions on using Ansible with Windows see [Ansible's Windows Guides](https://docs.ansible.com/ansible/latest/user_guide/windows.html)

## Build

```docker build --build-arg ANSIBLE_DOCKERHUB_VERSION=latest --build-arg PYWINRM_VERSION=0.4.1 -t leonyork/ansible:pywinrm .```

## Test

```docker run leonyork/ansible:pywinrm --version```