#!/bin/bash

vagrant init ubuntu/focal64

cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|

  config.vm.define "slave_1" do |slave_1|

    slave_1.vm.hostname = "slave-1"
    slave_1.vm.box = "ubuntu/focal64"
    slave_1.vm.network "private_network", ip: "192.168.56.59"

    slave_1.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

  config.vm.define "master" do |master|

    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", ip: "192.168.56.58"

    master.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
end
EOF

vagrant up
