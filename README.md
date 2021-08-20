# Auto Runner
An automated way of installing CircleCI's Runner offering on any host. This is accomplished by using Ansible.

## Prerequisites
There are very few prerequisites for running the auto runner script. 

The remote "target", where you want to install runner, must have Python and Pip installed. Python and Pip is installed on most operating systems by default, so this prerequisites should be easily achieved.
One way you can automate the install of Python and Pip is by utilizing `cloud-init` when spinning up VMs. Please check out the [user-data.yml](terraform/user-data.yml) for an example.

The second prerequisite is having Ansible installed where you want to launch the auto runner script from. Installing Ansible is pretty straight forward on most operating systems. Please refer to the [official docs](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for more info. Please note Windows can not run Ansible out of the bag. To get around this you can use WSL on Windows to run Ansible.

Lastly, once Ansible has been installed make sure to install the `community.general` collection. You can issue the following command to do so:

```
ansible-galaxy collection install community.general
```

## Running Auto Runner Script
In order to run the auto runner script please fill out [config.yaml](vars/config.yaml). This file controls various elements of the runner installation. Please note you can override any variable in the auto runner script. 
To find more variables to override please look under the roles directory. Each role, for example `circleci-cli`, has two directories that hold variables: `defaults` and `vars`. Any variables found in those directories/files can be overridden by adding them to the 
[config.yaml](vars/config.yaml) file. 

The `config.yaml` files holds the most common variables that users will want to customize. Here is a list of variables you can set:

| Value                      | Meaning                                                                                         | Defaults                     |
|----------------------------|-------------------------------------------------------------------------------------------------|------------------------------|
| CLI_INSTALL_DIR            | The path the CircleCI will be installed in                                                      | /usr/local/bin               |
| CLI_USER                   | The user the CircleCI will be configured for                                                    | Username used for SSH Access |
| NAMESPACE_CREATION         | Whether or not a namespace needs to be generated                                                | false                        |
| RESOURCE_CLASS_CREATION    | Whether or not a resource class needs to be generated                                           | true                         |
| RUNNER_TOKEN_CREATION      | Whether or not a runner token needs to be generated                                             | true                         |
| VCS_TYPE                   | The version control software you are using                                                      | github                       |
| NAMESPACE                  | The name of the namespace being utilized or created                                             | N/A                          |
| ORG_NAME                   | The name of the VSC organization the runner will utilize                                        | N/A                          |
| RESOURCE_CLASS             | The name of the resource class being utilized or created                                        | N/A                          |
| RESOURCE_CLASS_DESCRIPTION | A description of the resource class being utilized                                              | N/A                          |
| API_TOKEN                  | Your CircleCI Personal API Token being utilized                                                 | N/A                          |
| target_hosts               | The list of host(s) runner will be installed on based on the available hosts in your inventory  | N/A                          |


Once you have the `config.yaml` configured, you can run the following command to install Runner:

```
ansible-playbook -i inventory runner.yml
```

Please make sure to add your "target" host(s) to your inventory file. The inventory file included shows a couple examples of how you can add hosts to an inventory file. For more information please
refer to the Ansible docs linked [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

If working with AWS, GCP or other cloud providers you might want to look into dynamic inventories to sync your hosts for Ansible. More information can
be found [here](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html)

Here is an example of targeting hosts using a dynamic inventory for AWS EC2:

```
ansible-playbook -i aws_ec2.yaml runner.yml
``` 

Please note you will customize the `aws_ec2.yaml` file to fit your AWS EC2 environment.

## Tested Platforms
| Operating System | OS Version       | Architecture | Tested |
|------------------|------------------|--------------|--------|
| RHEL             | 8                | amd64        | YES    |
| RHEL             | 8                | arm64        | NO     |
| Ubuntu           | 20.04            | amd64        | YES    |
| Ubuntu           | 20.04            | arm64        | NO     |
| MacOS            | 11.5.1           | amd64        | YES    |
| Windows          | Server 2019 Base | amd64        | NO     |

## To Do
- Windows support does not exist but can be added
- Need to test on Arm64 resources. Shouldn't be an issue with arch aware code. Need `circleci cli` for arm64
