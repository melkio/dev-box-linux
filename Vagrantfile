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
#    config.vbguest.auto_update = true

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

  config.vm.provider "parallels" do |p, override|
    p.update_guest_tools = true
    
    p.name = VM_NAME
    p.cpus = VM_CPUS
    p.memory = VM_MEMORY

    # https://github.com/Parallels/vagrant-parallels/pull/362
    override.vm.synced_folder ".", "/vagrant", mount_options: ["share", "noatime", "host_inodes"] 
    
    p.customize ["set", :id, "--videosize", "256"]
    p.customize ["set", :id, "--3d-accelerate", "off"]
    p.customize ["set", :id, "--vertical-sync", "on"]
    p.customize ["set", :id, "--high-resolution", "on"]
    p.customize ["set", :id, "--sync-host-printers", "off"]
    p.customize ["set", :id, "--sync-default-printer", "off"]
    p.customize ["set", :id, "--auto-share-camera", "off"]
    p.customize ["set", :id, "--auto-share-bluetooth", "off"]
    p.customize ["set", :id, "--support-usb30", "off"]
    p.customize ["set", :id, "--autostart", "off"]
    p.customize ["set", :id, "--startup-view", "fullscreen"]
    p.customize ["set", :id, "--on-shutdown", "quit"]
    p.customize ["set", :id, "--faster-vm", "on"]
  end

  config.vm.provision "shell", path: "provision.sh"
end
