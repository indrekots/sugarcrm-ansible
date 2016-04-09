# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'socket'

def my_first_private_ipv4
  Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
end

def fail_with_message(msg)
  fail Vagrant::Errors::VagrantError.new, msg
end

host_ip = my_first_private_ipv4.ip_address()

ANSIBLE_PATH = __dir__
config_file = File.join(ANSIBLE_PATH, 'inventory', 'development', 'group_vars', 'all', 'common.yml')

unless Vagrant.has_plugin?("vagrant-hostsupdater")
  fail_with_message "vagrant-hostsupdater is not installed\nuse 'vagrant plugin install vagrant-hostsupdater' to install the required plugin"
end

unless Vagrant.has_plugin?("vagrant-hosts")
  fail_with_message "vagrant-hostsupdater is not installed\nuse 'vagrant plugin install vagrant-hosts' to install the required plugin"
end

if File.exists?(config_file)
  domain_name = YAML.load_file(config_file)['domain_name']
  local_site_path = YAML.load_file(config_file)['local_site_path']
else
  fail_with_message "#{config_file} was not found. Please set `ANSIBLE_PATH` in your Vagrantfile."
end

Vagrant.configure(2) do |config|

    config.vm.define "sugar", primary: true do |a|
        a.vm.box = "ubuntu/trusty64"
        a.vm.network "private_network", ip: "10.0.1.10"
        a.vm.hostname = "dev.mydomain.local"
        a.vm.synced_folder local_site_path, "/srv/sugar", owner: 'www-data', group: 'www-data', mount_options: ['dmode=777', 'fmode=775']

        a.vm.provider "virtualbox" do |vb|
          vb.memory = 4096
          vb.cpus = 1
        end
        a.vm.provision :ansible do |ansible|
            ansible.playbook = 'site.yml'
            ansible.inventory_path = 'inventory/development/hosts'
        end

        a.vm.provision :hosts do |provisioner|
            provisioner.add_host host_ip, ['host.machine']
        end
    end
end
