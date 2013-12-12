##
# Class that takes care of creating a Vagrant node with some presets
#
# Initialize using a hash of desired settings:
#
# config::   The Vagrant config object
# hostname:: The hostname _(default: none)_
# domain::   The domain name _(default: *hogent.be*)_
# ip::       The IP address _(default: none, set with DHCP)_
# netmask::  The network mask _(default: none)_
# mac::      The box's MAC address _(default: set by VirtualBox)_
# box::      The Vagrant box to use _(default: *centos64*)_
# box_url::  The download URL for the Vagrant box
#            _(default: from *packages.vstone.eu*)_
# gui::      Whether the VirtualBox GUI should be shown
#            _(default: *false*)_
# vboxnet::  Name of the VirtualBox host-only network to attach to
#            _(default: *vboxnet1*)_
#
class VagrantNode

  DOMAIN = 'hogent.be'
  BOX = 'centos64'
  BOX_URL = 'http://packages.vstone.eu/vagrant-boxes/centos-6.x-64bit-latest.box'
  VBOXNET = 'vboxnet1'

  def initialize(args)
    @config = args[:config]

    @hostname = args[:hostname]
    @domain = args[:domain] || DOMAIN

    @ip = args[:ip]
    @netmask = args[:netmask]

    @mac = args[:mac]

    @box = args[:box] || BOX
    @box_url = args[:box_url] || BOX_URL

    @gui = args[:gui] || false

    @vboxnet = args[:vboxnet] || VBOXNET
  end

  def setup
    @config.vm.define @hostname.intern do |node|
      node.vm.box = @box
      node.vm.box_url = @box_url

      node.vm.hostname = fqdn

      if !@ip.nil?
        node.vm.network :private_network, ip: @ip, netmask: @netmask
      else
        node.vm.network :private_network, type: :dhcp
      end

      node.vm.synced_folder '.', '/etc/puppet'

      node.vm.provider :virtualbox do |vb|
        vb.gui = @gui
        vb.name = @hostname
        vb.customize ['modifyvm', :id, '--cpus', 1]
        vb.customize ['modifyvm', :id, '--memory', 512]
        vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
        vb.customize ['modifyvm', :id, '--hostonlyadapter2', @vboxnet]
        vb.customize ['modifyvm', :id, '--macaddress2', mac] unless @mac.nil?
      end

      node.vm.provision :puppet do |puppet|
        puppet.manifest_file = 'site.pp'
        puppet.options = [
          '--hiera_config /etc/puppet/hiera.yaml',
          '--environment development'
        ]
      end

    end
  end

  private

  def fqdn
    @hostname + '.' + @domain
  end

  def mac
    @mac.tr(':', '')
  end

end
