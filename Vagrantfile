# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

    config.vm.box = "hashicorp/precise32" 

    config.vm.network "forwarded_port", guest: 80, host: 8080

    # http://stackoverflow.com/a/14050927/2779152
    config.vm.provision :shell, :inline => "sudo apt-get update && sudo apt-get install puppet -y"

    config.vm.provision "puppet" do |puppet|
        puppet.module_path = "puppet/modules"
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "init.pp"
        puppet.options = ['--verbose']
    end
 
    config.vm.provider :virtualbox do |vb|
        vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate//vagrant","1"]
    end

end
