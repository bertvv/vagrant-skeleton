# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'vagrant_helper'
require 'yaml'

Vagrant.configure('2') do |config|

  # load settings from Hiera, fetch values with
  #   hiera['key']
  # hiera = YAML.load_file('hiera/common.yaml')

  # Setup a new box (you can add more below)
  VagrantNode.new(
    config:   config,
    hostname: 'testbox',
    domain:   'example.com',
    ip:       '192.168.56.64',
    netmask:  '255.255.255.0',
  ).setup

end
