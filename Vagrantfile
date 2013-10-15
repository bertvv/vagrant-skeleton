# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for two boxes

VAGRANTFILE_API_VERSION = "2"

BOX_NAME = "centos64"
BOX_URL = "http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box"

HOST = 'testbox'
HOST_IP = '192.168.56.20'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URL

    config.vm.hostname = HOST
    config.vm.network :private_network, ip: HOST_IP
    config.vm.synced_folder ".", "/etc/puppet"

    config.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.name = HOST
        vb.customize ["modifyvm", :id, '--cpus', 1 ]
        vb.customize ["modifyvm", :id, '--memory', 512 ]
        # Uncomment if you use another Host-only network
        #vb.customize ["modifyvm", :id, '--hostonlyadapter2', 'vboxnet2']

        config.vm.provision :puppet do |puppet|
            puppet.manifest_file = "site.pp"
        end
    end

end
