#About
This repository contains Ansible Playbooks for setting up a local SugarCRM 7 development environment. 

#Getting started

##Install Vagrant
Vagrant is used to create a virtual machine.

* Make sure vagrant is installed
* Install the latest version of VirtualBox (or any other supported provider)

##Set up folder structure

Vagrant mounts SugarCRM from your local filesystem. The following diagram shows where Vagrant expects you to have placed Sugar's source code relative to `Vagrantfile`. 

```
.
├── sugarcrm-ansible/
│   └── Vagrantfile
└── sugarcrm/

```

##Required Vagrant plugins
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts)

If plugins are missing, vagrant commands will fail and prompt you to install any missing plugins.

##Configure variables
To configure your install, make changes in `inventory/development/group_vars/all/common.yml` and `group_vars/all/common.yml`.

##vagrant up

After setting up your folder structure, you should run `vagrant up`. A new VM is created and Ansible is used for provisioning. 
You will be prompted for your sudo password since *vagrant-hostsupdater* will make changes in your `/etc/hosts` file and map a domain name to point to the newly created VM.

If Ansible finished successfully, then point your browser to the domain name you specified in your inventory and you should see a fresh install of SugarCRM.

#Deployment

##Create a deploy key
For deployments to work you should host your Sugar source code in a Git repository. Then generate a deploy key which allows you to access the repository.
Look at `inventory/development/group_vars/deploy_key.yml` for example and replace it with your key.

##Run Ansible deploy playbook
Running `ansible-playbook -i inventory/development/hosts deploy.yml -k -K` will start a deployment to your local environment.

##Create new inventory entry
Creating a new inventory entry for a production environment is easy. Create a new folder `inventory/prod` and copy the contents of `inventory/development` into the newly created directory.
Replace all variables with values for the new environment. Make sure the `hosts` file contains correct addresses.

#Contribute
All contributions are welcome. Create issues or submit pull requests. The contents of this repository is not very general to fit all use cases (e.g. currently works only for Debian based distros). 