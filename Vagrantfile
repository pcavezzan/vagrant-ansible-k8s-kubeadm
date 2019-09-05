# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--audio", "none"]
  end

  (0..0).each do |n|
    config.vm.define "cpl-#{n}" do |c|
      c.vm.hostname = "cpl-#{n}"
      c.vm.network "private_network", ip: "192.168.200.1#{n}"
    end
  end

  (0..2).each do |n|
    config.vm.define "worker-#{n}" do |c|
      c.vm.hostname = "worker-#{n}"
      c.vm.network "private_network", ip: "192.168.200.2#{n}"
    end
  end


  config.vm.define "lb-0" do |c|
    c.vm.hostname = "lb-0"
    c.vm.network "private_network", ip: "192.168.200.40"

    c.vm.provision :shell, :path => "scripts/vagrant-setup-haproxy.bash"
    
    c.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
    end
  end
end
