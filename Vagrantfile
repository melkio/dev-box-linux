# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vbguest.auto_update = true
  
  config.vm.box = "bento/debian-10.5"
  config.vm.box_check_update = false
  config.vm.hostname = "atene"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "dev-box"
    vb.cpus = 2
    vb.memory = 4096
    vb.gui = true

    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--acpi", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
end