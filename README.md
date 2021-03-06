# My linux development environment

This repository automates the setup of my linux development environment

## Requirements

Automation is built around [Vagrant](https://www.vagrantup.com/).  
Others requirements are:

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant vbguest plugin](https://github.com/dotless-de/vagrant-vbguest)

*or*

* [Parallels Pro](https://www.parallels.com/products/desktop/pro)
* [Vagrant Parallels provider](https://github.com/Parallels/vagrant-parallels)

## How To Build The Virtual Machine

Building the virtual machine is this easy:

```
git clone https://github.com/melkio/dev-box-linux.git helsinki
cd helsinki/
cp ~/.ssh/id_rsa* .
vagrant up
```

That's it.

## RAM and CPUs

By default, the VM starts with 8 GB of RAM and 2 CPUs.
