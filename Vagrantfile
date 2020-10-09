# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_NAME = "helsinki"
VM_CPUS = "2"
VM_MEMORY = "8192"

Vagrant.configure("2") do |config|  
  config.vm.box = "bento/debian-10.5"
  config.vm.box_check_update = false
  config.vm.hostname = VM_NAME

  config.vm.provider "virtualbox" do |vb|
    config.vbguest.auto_update = true

    vb.name = VM_NAME
    vb.cpus = VM_CPUS
    vb.memory = VM_MEMORY
    vb.gui = true

    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--acpi", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provider "parallels" do |parallels, override|
    parallels.update_guest_tools = true
    
    parallels.name = VM_NAME
    parallels.cpus = VM_CPUS
    parallels.memory = VM_MEMORY

    # https://github.com/Parallels/vagrant-parallels/pull/362
    override.vm.synced_folder ".", "/vagrant", mount_options: ["share", "noatime", "host_inodes"] 
    
    parallels.customize ["set", :id, "--videosize", "256"]
    parallels.customize ["set", :id, "--3d-accelerate", "off"]
    parallels.customize ["set", :id, "--vertical-sync", "on"]
    parallels.customize ["set", :id, "--high-resolution", "on"]
    parallels.customize ["set", :id, "--sync-host-printers", "off"]
    parallels.customize ["set", :id, "--sync-default-printer", "off"]
    parallels.customize ["set", :id, "--auto-share-camera", "off"]
    parallels.customize ["set", :id, "--auto-share-bluetooth", "off"]
    parallels.customize ["set", :id, "--support-usb30", "off"]
    parallels.customize ["set", :id, "--autostart", "off"]
    parallels.customize ["set", :id, "--startup-view", "fullscreen"]
    parallels.customize ["set", :id, "--on-shutdown", "quit"]
    parallels.customize ["set", :id, "--faster-vm", "on"]
  end

  config.vm.provision "shell", path: "provision.sh"
end
