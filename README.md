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
In order to run the auto runner script please fill out [config.yml](vars/config.yml). This file controls various elements of the runner installation. Please note you can override any variable in the auto runner script. 
To find more variables to override please look under the roles directory. Each role, for example `circleci-cli`, has two directories that hold variables: `defaults` and `vars`. Any variables found in those directories/files can be overridden by adding them to the 
[config.yml](vars/config.yml) file. 

The `config.yml` files holds the most common variables that users will want to customize. Here is a list of variables you can set:

| Variable                   | Meaning                                                                                         | Defaults                     |
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


Once you have the `config.yml` configured, you can run the following command to install Runner:

```
ansible-playbook -i inventory runner.yml
```

Please make sure to add your "target" host(s) to your inventory file. The inventory file included shows a couple examples of how you can add hosts to an inventory file. For more information please
refer to the Ansible docs linked [here](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html).

If working with AWS, GCP or other cloud providers you might want to look into dynamic inventories to sync your hosts for Ansible. More information can
be found [here](https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html).

Here is an example of targeting hosts using a dynamic inventory for AWS EC2:

```
ansible-playbook -i aws_ec2.yml runner.yml
``` 

Please note you will customize the `aws_ec2.yml` file to fit your AWS EC2 environment.


### ARM64 Runner
When trying to deploy CircleCI's Runner offering on `arm64` you will need to do a couple extra steps to get the auto runner script to to work. 
This is due to the lack of support for `arm64` on CircleCI CLI. Once `arm64` support is released for CircleCI CLI these extra steps will not be needed.

In the [config.yml](vars/config.yml) file, you will need to set a couple variables to certain values. Please refer to the table below:

| Variable                | Meaning                                                                         | Required Value                    |
|-------------------------|---------------------------------------------------------------------------------|-----------------------------------|
| NAMESPACE_CREATION      | Due to lack Arm64 on the CLI you can not create a namespace via the script      | false                             |
| RESOURCE_CLASS_CREATION | Due to lack Arm64 on the CLI you can not create a resource class via the script | false                             |
| RUNNER_TOKEN_CREATION   | Due to lack Arm64 on the CLI you can not create an auth token via the script    | false                             |
| AUTH_TOKEN              | N/A                                                                             | Valid AUTH_TOKEN generated by CLI |

You will need to generate the namespace, resource class and auth token separately from the auto runner script. Then plug into those values into 
the [config.yml](vars/config.yml).

## Tested Platforms
| Operating System | OS Version       | Architecture | Tested |
|------------------|------------------|--------------|--------|
| RHEL             | 8                | amd64        | YES    |
| RHEL             | 8                | arm64        | YES    |
| Ubuntu           | 20.04            | amd64        | YES    |
| Ubuntu           | 20.04            | arm64        | NO     |
| MacOS            | 11.5.1           | amd64        | YES    |
| Windows          | Server 2019 Base | amd64        | NO     |

## To Do
- Windows support does not exist but can be added


## Runner Set up & Tear down:
### Tear down:
- in terminal, `cd terraform` and enter `➜  auto-runner git:(main) ✗ terraform destroy -var-file=demo.tfvars` 
- this will tear down the current running instance inside of [aws](https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#Instances:keyName=joe_mac) 
- 
### Set up:
- `cd terraform` directoy
- cmd `terraform apply -var-file=demo.tfvars`
- grab new IP address from terminal and update file `terraform/vars/config.yml` at `target_hosts`
- Go back to home directory in terminal `cd ..`
- Run ansible: `ansible-playbook -i aws_ec2.yml runner.yml -u ansible`
- This will kick off the new instance and runner will be running 