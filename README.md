# Vagrant skeleton

An opinionated skeleton for Vagrant projects with Puppet provisioning.

## Features

### Network settings

VMs are created with two network interfaces:

- Adapter 1, NAT: so the VM can reach the Internet and Vagrant can communicate with it over SSH
- Adapter 2, Host-only: so the VM can be accessed over a 'normal' TCP/IP network without having to set up port forwarding.

### Shared folders

In addition to the standard directories shared by Vagrant (e.g. `/vagrant`), the project directory is shared as `/etc/puppet`. That way, a lot of things 'just work'. In the [documented way](http://docs.vagrantup.com/v2/provisioning/puppet_apply.html) to share folders with the VM, it is hard to set up e.g. the `files/` direcory and Hiera. A `fileserver.conf` and `hiera.conf` is provided that should work as expected

### `vagrant_helper.rb`

Thanks to `vagrant_helper.rb`, the definition of a node is much more concise than described in the Vagrant manual:

```ruby

  VagrantNode.new(
    config: config,
    hostname: 'myhost',
    domain: 'example.com',
    ip: '192.168.56.64',
    netmask: '255.255.255.0',
  ).setup
```

Most settings can be omitted, in that case a sane default is chosen. See the documentation in `vagrant_helper.rb` for more information.

### Hiera

Hiera is set up and can be used in both Puppet manifests as the Vagrantfile. You may want to adapt the `hiera.yaml` configuration file to your environment, especially the `:hierarchy:` setting.

### Module management

Generic and third party repositories are managed through [librarian-puppet](https://github.com/rodjek/librarian-puppet). If you run `librarian-puppet init` in the project root, a `modules/` directory will be created with Puppetlab's `stdlib` and `concat` modules initialised. Modify `Puppetfile` to your liking and see _librarian-puppet_'s documentation for mor information.

Site-specific modules that are kept under source control within this repository can be put under `site-modules/`. This directory is added to Puppet's `modulepath`.

## Contributing

Your feedback, bug reports, or even better, pull requests are greatly appreciated!
