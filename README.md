# Auto Runner
An automated way of installing CircleCI's Runner offering on any host. This is accomplished by using Ansible.

## Prerequisites
There are very few prerequisites for running auto runner script. The remote "target", where you want to install runner, must have Python and Pip installed. Python and Pip is installed on most operating systems by default so this prerequisites should be easily achieved.
If you want to automate the install of Python and Pip you can utilize `cloud-init` when spinning up VMs. Please check out the [user-data.yml](terraform/user-data.yml) for an example.

The second is having ansible installed where you want to launch the auto runner script from. Installing Ansible is pretty straight forward on most operating systems. Please refer to the official docs for more info. Please note Windows is not supported out of the bag. You can use
WSL to run Ansible on your Windows host.

Lastly, once Ansible has been installed make sure to install the `community.general` collection. You can issue the following command:

```
ansible-galaxy collection install community.general
```

## Running Auto Runner Script - WIP
In order to run the auto runner script please fill out [config.yaml](vars/config.yaml). This file controls various elements of the runner installation. Once you have the file configure how you want run:

```
ansible-playbook -i inventory runner.yml
```

Please make sure to add your "target" host to your inventory file. If working with AWS, GCP or other cloud providers you might want to look into dynamic inventories to sync your hosts for Ansible. 

## Tested Platforms
- RHEL 8 - amd64
- Ubuntu - amd64
- MacOS  - amd64

## To Do
- Windows support does not exist but can be added
- Need to test on Arm64 resources. Shouldn't be an issue with arch aware code. Need `circleci cli` for arm64
