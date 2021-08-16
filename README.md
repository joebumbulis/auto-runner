# Auto Runner
An automated way of installing Runner on any host. This is accomplished by using Ansible. 

## Prerequisites
There are very few prerequisites for running the auto runner ansible playbook. The remote "target", aka when you want to install runner, must have Python installed. Python is installed on most operating systems by default so this prerequisites should be easily achieved.

The second is having ansible installed where you want to launch the ansible playbook from. Installing Ansible is pretty straight forward on most operating systems. Please refer to the official docs for more info.

Lastly, once ansible has been installed make sure to install the `community.general` collection. You can issue the following command:

```
ansible-galaxy collection install community.general
```

## Running Auto Runner Playbook - WIP
Some examples:

```
ansible-playbook -i inventory runner.yml --ask-become-pass -e "target_hosts=ubuntu-amd64-aws API_TOKEN=XXXXXXXXXXXXXXX  NAMESPACE=crowley-namespace ORG_NAME=james-crowley RESOURCE_CLASS=ubuntu_amd64_aws RESOURCE_CLASS_DESCRIPTION='Ubuntu 20.04 amd64 on AWS' RUNNER_NICKNAME=ubuntu_amd64"
```


## Tested Platforms
- RHEL 8 - amd64
- Ubuntu - amd64
- MacOS  - amd64

## WIP
- Windows support does not exist but can be added
- Need to test on Arm64 resources. Shouldn't be an issue with arch aware code. Need `circleci cli` for arm64
